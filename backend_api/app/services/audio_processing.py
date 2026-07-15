"""
audio_processing.py
Handles audio loading, noise reduction, MFCC extraction, and feature computation.
"""
import numpy as np
import librosa
import noisereduce as nr
from app.config import SAMPLE_RATE, N_MFCC, N_FFT, HOP_LENGTH, MAX_PAD_LEN, DURATION


# Known non-audio magic bytes signatures
_FORBIDDEN_SIGNATURES = [
    (b'\x89PNG',  'PNG image'),
    (b'\xff\xd8\xff', 'JPEG image'),
    (b'GIF8',    'GIF image'),
    (b'BM',      'BMP image'),
    (b'%PDF',    'PDF document'),
    (b'PK\x03\x04', 'ZIP/Office document'),
    (b'\x1f\x8b', 'GZIP archive'),
    (b'\x42\x4d', 'BMP image'),
    (b'\x00\x00\x00', 'MP4/video container'),  # ftyp box often starts with 0x00000000
    (b'\x1a\x45\xdf\xa3', 'WebM/MKV video'),
    (b'RIFF', None),   # RIFF is OK — real WAV starts with RIFF
    (b'ID3',  None),   # ID3 tag is OK — MP3 with ID3
    (b'\xff\xfb', None),  # MP3 frame sync — OK
    (b'\xff\xf3', None),  # MP3 frame sync — OK
    (b'\xff\xf2', None),  # MP3 frame sync — OK
]

_AUDIO_ALLOWED_SIGNATURES = [
    b'RIFF',       # WAV
    b'ID3',        # MP3 with ID3 tag
    b'\xff\xfb',   # MP3 frame
    b'\xff\xf3',   # MP3 frame
    b'\xff\xf2',   # MP3 frame
    b'\xff\xe0',   # MP3 frame
    b'\xff\xe1',   # MP3 frame
    b'\xff\xe2',   # MP3 frame
    b'\xff\xe3',   # MP3 frame
    b'fLaC',       # FLAC (fallback)
    b'OggS',       # OGG (fallback)
]


def validate_audio_file(file_path: str) -> None:
    """
    Validate that the file actually contains audio data by checking magic bytes.
    Raises ValueError if the file is not a valid audio file.
    """
    try:
        with open(file_path, 'rb') as f:
            header = f.read(12)
    except OSError as e:
        raise ValueError(f"Tidak dapat membaca file: {e}")

    if len(header) < 4:
        raise ValueError("File terlalu kecil untuk dianalisis")

    # Check for forbidden (non-audio) signatures
    for sig, label in _FORBIDDEN_SIGNATURES:
        if label is None:
            continue  # skip allowed markers defined in forbidden list
        if header[:len(sig)] == sig:
            raise ValueError(
                f"File terdeteksi sebagai {label}, bukan file audio. "
                "Pastikan Anda mengunggah file .WAV atau .MP3 yang asli."
            )

    # Check that at least one known audio signature matches
    is_audio = any(header[:len(sig)] == sig for sig in _AUDIO_ALLOWED_SIGNATURES)
    if not is_audio:
        raise ValueError(
            "File tidak dapat dikenali sebagai audio .WAV atau .MP3 yang valid. "
            "File mungkin rusak atau merupakan format lain yang diubah ekstensinya."
        )

def load_and_preprocess(file_path: str):
    """
    Load audio file, reduce noise, normalize amplitude.
    Returns: (audio_array, sample_rate, duration_seconds)
    Raises ValueError if file is not valid audio.
    """
    # Step 0: Validate file content via magic bytes BEFORE handing to librosa
    validate_audio_file(file_path)

    # Load audio
    try:
        audio, sr = librosa.load(file_path, sr=SAMPLE_RATE, mono=True)
    except Exception as e:
        raise ValueError(
            f"File tidak dapat dibaca sebagai audio: {e}. "
            "Pastikan file tidak rusak dan merupakan format .WAV atau .MP3 yang valid."
        )

    if len(audio) == 0:
        raise ValueError("File audio tidak berisi sinyal suara (durasi 0 detik).")

    duration = librosa.get_duration(y=audio, sr=sr)

    if duration < 0.5:
        raise ValueError(
            f"Durasi audio terlalu pendek ({duration:.2f} detik). "
            "File harus berisi rekaman minimal 0.5 detik."
        )

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
    Model expects input shape: (batch, N_MFCC=40, MAX_PAD_LEN=216, 1)
    i.e. (batch, n_mfcc, time_steps, 1) — NOT transposed.
    """
    mfcc = librosa.feature.mfcc(
        y=audio,
        sr=sr,
        n_mfcc=N_MFCC,
        n_fft=N_FFT,
        hop_length=HOP_LENGTH,
    )
    # mfcc shape from librosa: (N_MFCC, time_steps) = (40, T)
    # Model expects: (N_MFCC, MAX_PAD_LEN) = (40, 216)
    # DO NOT transpose — keep (40, T) and pad/truncate on axis=1 (time axis)

    # Pad or truncate along time axis (axis=1)
    if mfcc.shape[1] < MAX_PAD_LEN:
        pad_width = MAX_PAD_LEN - mfcc.shape[1]
        mfcc = np.pad(mfcc, ((0, 0), (0, pad_width)), mode='constant')
    else:
        mfcc = mfcc[:, :MAX_PAD_LEN]

    # Normalize MFCC
    mfcc = (mfcc - np.mean(mfcc)) / (np.std(mfcc) + 1e-8)

    # Reshape to (1, N_MFCC, MAX_PAD_LEN, 1) for CNN input
    mfcc = mfcc.reshape(1, N_MFCC, MAX_PAD_LEN, 1)

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
