"""
main.py — VoxGrade FastAPI AI Inference Server
Endpoint: POST /api/v1/analyze
"""
import os
import shutil
import tempfile
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict
import uvicorn

from app.services.audio_processing import (
    load_and_preprocess,
    extract_mfcc,
    compute_articulation_score,
    compute_intonation_score,
)
from app.services.model_inference import predict_emotion, compute_overall_score
from app.services.stt_service import transcribe_audio, analyze_sentiment, generate_feedback

app = FastAPI(
    title="AssessAI",
    description="Speech Emotion Recognition & Analysis API for AssessAI",
    version="1.0.0",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class AnalysisResponse(BaseModel):
    emotion_label: str
    emotion_probabilities: Dict[str, float]
    articulation_score: float
    intonation_score: float
    overall_score: float
    transcription: str
    feedback: str
    duration: float


@app.get("/")
async def root():
    return {"message": "AssessAI Server is running", "version": "1.0.0"}


@app.get("/health")
async def health():
    return {"status": "ok", "service": "assessai"}


@app.post("/api/v1/analyze", response_model=AnalysisResponse)
async def analyze_audio(file: UploadFile = File(...)):
    """
    Analyze audio file:
    1. Noise reduction + normalization
    2. MFCC extraction
    3. CNN-LSTM emotion classification
    4. Articulation & intonation scoring
    5. Whisper transcription
    6. Sentiment analysis
    7. Feedback generation
    """
    # Validate file type
    allowed_types = ["audio/wav", "audio/mpeg", "audio/mp3", "audio/wave", "audio/x-wav", "audio/x-mpeg"]
    filename = file.filename or ""
    
    if not (file.content_type in allowed_types or filename.lower().endswith(('.wav', '.mp3'))):
        raise HTTPException(
            status_code=400,
            detail="Hanya format .wav dan .mp3 yang didukung"
        )

    # Save uploaded file to temp directory
    suffix = ".wav" if filename.lower().endswith(".wav") else ".mp3"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp_file:
        shutil.copyfileobj(file.file, tmp_file)
        tmp_path = tmp_file.name

    try:
        # Step 1: Load & preprocess audio
        audio, sr, duration = load_and_preprocess(tmp_path)

        # Step 2: Extract MFCC features
        mfcc_features = extract_mfcc(audio, sr)

        # Step 3: Emotion classification via CNN-LSTM
        emotion_result = predict_emotion(mfcc_features)
        emotion_label = emotion_result["emotion_label"]
        emotion_probs = emotion_result["emotion_probabilities"]
        emotion_confidence = emotion_result["confidence"]

        # Step 4: Compute articulation & intonation scores
        articulation_score = compute_articulation_score(audio, sr)
        intonation_score = compute_intonation_score(audio, sr)

        # Step 5: Transcribe audio with Whisper
        transcription = transcribe_audio(tmp_path)

        # Step 6: Sentiment analysis
        sentiment_score = analyze_sentiment(transcription)

        # Step 7: Overall score
        overall_score = compute_overall_score(
            emotion_label,
            emotion_confidence,
            articulation_score,
            intonation_score,
            sentiment_score,
        )

        # Step 8: Generate feedback
        feedback = generate_feedback(
            emotion_label,
            articulation_score,
            intonation_score,
            sentiment_score,
            overall_score,
        )

        return AnalysisResponse(
            emotion_label=emotion_label,
            emotion_probabilities=emotion_probs,
            articulation_score=articulation_score,
            intonation_score=intonation_score,
            overall_score=overall_score,
            transcription=transcription,
            feedback=feedback,
            duration=duration,
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analisis gagal: {str(e)}")
    
    finally:
        # Cleanup temp file
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)


if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
