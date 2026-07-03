import os

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_DIR = os.path.join(BASE_DIR, "models")
MODEL_PATH = os.path.join(MODEL_DIR, "model_final_indowave.keras")

# Audio processing parameters
# Model input shape: (batch, N_MFCC, MAX_PAD_LEN, 1) = (batch, 40, 216, 1)
SAMPLE_RATE = 22050
DURATION = 3  # seconds per segment
N_MFCC = 40
N_FFT = 2048
HOP_LENGTH = 512
MAX_PAD_LEN = 216  # Fixed length for MFCC time axis (matches model training)

# Emotion labels (5 classes from trained model)
EMOTION_LABELS = ["neutral", "happy", "surprise", "disgust", "disappointed"]

# Emotion display mapping (for user-friendly output)
EMOTION_DISPLAY = {
    "neutral": "Netral",
    "happy": "Percaya Diri / Antusias",
    "surprise": "Terkejut / Spontan",
    "disgust": "Tidak Nyaman",
    "disappointed": "Kecewa / Kurang Semangat",
}

# Scoring weights
WEIGHTS = {
    "emotion": 0.40,
    "articulation": 0.30,
    "intonation": 0.20,
    "sentiment": 0.10,
}

# Positive emotion scores for scoring (higher = better for presentation)
EMOTION_PRESENTATION_SCORE = {
    "neutral": 70,
    "happy": 90,
    "surprise": 75,
    "disgust": 30,
    "disappointed": 25,
}

# Whisper model size
# 'tiny' = ~39MB, cepat tapi kurang akurat
# 'base' = ~74MB, akurasi lebih baik untuk BI  ← DIGUNAKAN
# 'small' = ~244MB, sangat akurat tapi butuh GPU/RAM besar
WHISPER_MODEL = "base"  # Upgrade dari tiny untuk akurasi Bahasa Indonesia
WHISPER_LANGUAGE = "id"  # Indonesian
