"""
audio_processing.py
Handles audio loading, noise reduction, MFCC extraction, and feature computation.
"""
import numpy as np
import librosa
import noisereduce as nr
from app.config import SAMPLE_RATE, N_MFCC, N_FFT, HOP_LENGTH, MAX_PAD_LEN, DURATION


def load_and_preprocess(file_path: str):
    """
    Load audio file, reduce noise, normalize amplitude.
    Returns: (audio_array, sample_rate, duration_seconds)
    """
    # Load audio
    audio, sr = librosa.load(file_path, sr=SAMPLE_RATE, mono=True)
    duration = librosa.get_duration(y=audio, sr=sr)

    # Noise reduction using spectral gating
    audio_denoised = nr.reduce_noise(y=audio, sr=sr, stationary=False)

    # Amplitude normalization
    max_amp = np.max(np.abs(audio_denoised))
    if max_amp > 0:
        audio_normalized = audio_denoised / max_amp
    else:
        audio_normalized = audio_denoised

    return audio_normalized, sr, duration


def extract_mfcc(audio: np.ndarray, sr: int) -> np.ndarray:
    """
    Extract MFCC features from audio.
    Returns: numpy array of shape (1, MAX_PAD_LEN, N_MFCC, 1) for CNN input.
    """
    mfcc = librosa.feature.mfcc(
        y=audio,
        sr=sr,
        n_mfcc=N_MFCC,
        n_fft=N_FFT,
        hop_length=HOP_LENGTH,
    )

    # Transpose: (time_steps, n_mfcc)
    mfcc = mfcc.T

    # Pad or truncate to fixed length
    if mfcc.shape[0] < MAX_PAD_LEN:
        pad_width = MAX_PAD_LEN - mfcc.shape[0]
        mfcc = np.pad(mfcc, ((0, pad_width), (0, 0)), mode='constant')
    else:
        mfcc = mfcc[:MAX_PAD_LEN, :]

    # Normalize MFCC
    mfcc = (mfcc - np.mean(mfcc)) / (np.std(mfcc) + 1e-8)

    # Reshape to (1, MAX_PAD_LEN, N_MFCC, 1) for CNN-LSTM
    mfcc = mfcc.reshape(1, MAX_PAD_LEN, N_MFCC, 1)

    return mfcc


def compute_articulation_score(audio: np.ndarray, sr: int) -> float:
    """
    Estimate articulation quality based on RMS energy and zero-crossing rate.
    Returns score 0-100.
    """
    # Root Mean Square energy
    rms = librosa.feature.rms(y=audio)[0]
    rms_mean = np.mean(rms)
    rms_std = np.std(rms)

    # Zero-crossing rate (indicates clarity of consonants)
    zcr = librosa.feature.zero_crossing_rate(audio)[0]
    zcr_mean = np.mean(zcr)

    # Spectral centroid (brightness / clarity)
    spec_centroid = librosa.feature.spectral_centroid(y=audio, sr=sr)[0]
    centroid_mean = np.mean(spec_centroid)

    # Normalize to 0-100 score
    # Energy consistency: low std relative to mean = more consistent
    consistency = max(0, 1 - (rms_std / (rms_mean + 1e-8)))
    
    # Clarity indicator from spectral centroid (optimal range: 1000-3000 Hz)
    clarity = min(1.0, centroid_mean / 2500)

    # ZCR in a good range (0.05-0.15 for speech)
    zcr_score = 1.0 - abs(zcr_mean - 0.10) / 0.10
    zcr_score = max(0, min(1, zcr_score))

    articulation = (consistency * 0.4 + clarity * 0.4 + zcr_score * 0.2) * 100
    return round(min(100, max(0, articulation)), 2)


def compute_intonation_score(audio: np.ndarray, sr: int) -> float:
    """
    Estimate intonation quality based on pitch variation.
    Returns score 0-100.
    """
    # Extract fundamental frequency (pitch)
    f0, voiced_flag, _ = librosa.pyin(
        audio,
        fmin=librosa.note_to_hz('C2'),
        fmax=librosa.note_to_hz('C7'),
        sr=sr,
    )

    # Filter out unvoiced frames
    voiced_f0 = f0[voiced_flag]

    if len(voiced_f0) < 10:
        return 50.0  # Neutral score if not enough voiced frames

    # Compute pitch variation statistics
    f0_std = np.std(voiced_f0)
    f0_mean = np.mean(voiced_f0)
    variation_coeff = f0_std / (f0_mean + 1e-8)

    # Good intonation has moderate variation (not monotone, not erratic)
    # Optimal coefficient of variation: 0.1 - 0.3
    if 0.1 <= variation_coeff <= 0.3:
        intonation = 85 + (variation_coeff - 0.1) / 0.2 * 15
    elif variation_coeff < 0.1:
        # Too monotone
        intonation = variation_coeff / 0.1 * 85
    else:
        # Too erratic
        intonation = max(30, 100 - (variation_coeff - 0.3) * 100)

    return round(min(100, max(0, intonation)), 2)
