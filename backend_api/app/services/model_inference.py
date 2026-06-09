"""
model_inference.py
Loads the trained CNN-LSTM Keras model and runs emotion classification.
"""
import numpy as np
import tensorflow as tf
from app.config import MODEL_PATH, EMOTION_LABELS, EMOTION_PRESENTATION_SCORE, WEIGHTS

# Singleton model instance
_model = None


def get_model():
    """Load model once and cache it."""
    global _model
    if _model is None:
        print(f"[ModelInference] Loading model from: {MODEL_PATH}")
        _model = tf.keras.models.load_model(MODEL_PATH)
        print(f"[ModelInference] Model loaded. Input shape: {_model.input_shape}")
    return _model


def predict_emotion(mfcc_features: np.ndarray) -> dict:
    """
    Run emotion classification on MFCC features.
    
    Args:
        mfcc_features: numpy array of shape (1, MAX_PAD_LEN, N_MFCC, 1)
    
    Returns:
        dict with 'emotion_label', 'emotion_probabilities'
    """
    model = get_model()

    # Run inference
    predictions = model.predict(mfcc_features, verbose=0)
    probabilities = predictions[0]  # Shape: (num_classes,)

    # Get predicted class
    predicted_idx = int(np.argmax(probabilities))
    predicted_label = EMOTION_LABELS[predicted_idx]

    # Build probability dict
    emotion_probabilities = {
        label: float(round(probabilities[i], 4))
        for i, label in enumerate(EMOTION_LABELS)
    }

    return {
        "emotion_label": predicted_label,
        "emotion_probabilities": emotion_probabilities,
        "confidence": float(round(probabilities[predicted_idx], 4)),
    }


def compute_emotion_score(emotion_label: str, confidence: float) -> float:
    """
    Convert emotion label to a presentation quality score (0-100).
    Weighted by model confidence.
    """
    base_score = EMOTION_PRESENTATION_SCORE.get(emotion_label, 50)
    # Weight by confidence: more confident prediction = more reliable score
    return round(base_score * 0.7 + confidence * base_score * 0.3, 2)


def compute_overall_score(
    emotion_label: str,
    emotion_confidence: float,
    articulation_score: float,
    intonation_score: float,
    sentiment_score: float,
) -> float:
    """
    Compute weighted overall score based on rubric weights.
    """
    emotion_score = compute_emotion_score(emotion_label, emotion_confidence)
    
    overall = (
        emotion_score * WEIGHTS["emotion"] +
        articulation_score * WEIGHTS["articulation"] +
        intonation_score * WEIGHTS["intonation"] +
        sentiment_score * WEIGHTS["sentiment"]
    )
    
    return round(min(100, max(0, overall)), 2)
