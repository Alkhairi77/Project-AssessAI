"""
stt_service.py
Speech-to-Text using OpenAI Whisper (offline) and basic sentiment analysis.
"""
import re
import whisper
from app.config import WHISPER_MODEL, WHISPER_LANGUAGE

# Singleton whisper model
_whisper_model = None


def get_whisper_model():
    """Load Whisper model once and cache it."""
    global _whisper_model
    if _whisper_model is None:
        print(f"[STT] Loading Whisper model: {WHISPER_MODEL}")
        _whisper_model = whisper.load_model(WHISPER_MODEL)
        print("[STT] Whisper model loaded.")
    return _whisper_model


def transcribe_audio(file_path: str) -> str:
    """
    Transcribe audio file to text using Whisper.
    Returns transcription string.
    """
    try:
        model = get_whisper_model()
        result = model.transcribe(
            file_path,
            language=WHISPER_LANGUAGE,
            task="transcribe",
            fp16=False,
        )
        transcription = result.get("text", "").strip()
        return transcription
    except Exception as e:
        print(f"[STT] Transcription error: {e}")
        return ""


def analyze_sentiment(text: str) -> float:
    """
    Simple rule-based sentiment analysis for Indonesian text.
    Returns a sentiment score 0-100 (higher = more positive/professional).
    """
    if not text or len(text.strip()) < 5:
        return 50.0

    text_lower = text.lower()

    # Positive professional keywords
    positive_words = [
        "baik", "bagus", "benar", "tepat", "jelas", "efisien", "optimal",
        "berhasil", "sukses", "meningkat", "berkembang", "inovatif", "kreatif",
        "solusi", "kesimpulan", "analisis", "strategi", "implementasi",
        "terima kasih", "dengan demikian", "oleh karena itu", "kesimpulannya",
        "pertama", "kedua", "ketiga", "selanjutnya", "kemudian", "akhirnya",
    ]

    # Negative / unprofessional keywords
    negative_words = [
        "maaf", "mohon maaf", "tidak bisa", "gagal", "salah", "error",
        "bingung", "tidak tahu", "lupa", "kurang", "belum", "tidak jelas",
        "apa ya", "hmm", "eh", "ah", "um", "anu", "gitu", "kayak",
    ]

    # Filler words (reduce professionalism)
    filler_words = ["ee", "eh", "ah", "um", "hmm", "anu", "gitu", "kan", "tuh", "nih"]

    words = re.findall(r'\b\w+\b', text_lower)
    total_words = max(len(words), 1)

    positive_count = sum(1 for w in words if w in positive_words)
    negative_count = sum(1 for w in words if w in negative_words)
    filler_count = sum(1 for w in words if w in filler_words)

    # Calculate ratios
    positive_ratio = positive_count / total_words
    negative_ratio = negative_count / total_words
    filler_ratio = filler_count / total_words

    # Base score
    sentiment_score = (
        50
        + (positive_ratio * 200)
        - (negative_ratio * 150)
        - (filler_ratio * 100)
    )

    return round(min(100, max(0, sentiment_score)), 2)


def generate_feedback(
    emotion_label: str,
    articulation_score: float,
    intonation_score: float,
    sentiment_score: float,
    overall_score: float,
) -> str:
    """
    Generate automated feedback text in Indonesian based on analysis results.
    """
    feedbacks = []

    # Emotion feedback
    emotion_feedback = {
        "neutral": "Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.",
        "happy": "Ekspresi suara Anda positif dan antusias. Pertahankan energi ini dalam presentasi!",
        "surprise": "Terdapat momen spontanitas dalam suara Anda. Pastikan tetap terkontrol dan profesional.",
        "disgust": "Terdeteksi ekspresi ketidaknyamanan. Fokuslah pada materi dan coba lebih rileks.",
        "disappointed": "Terdeteksi ekspresi kurang semangat. Tingkatkan kepercayaan diri dan antusiasme Anda.",
    }
    feedbacks.append(emotion_feedback.get(emotion_label, "Pertahankan kontrol emosi suara Anda."))

    # Articulation feedback
    if articulation_score >= 80:
        feedbacks.append("Artikulasi kata-kata Anda sudah sangat jelas dan mudah dipahami.")
    elif articulation_score >= 60:
        feedbacks.append("Artikulasi cukup baik, namun beberapa kata perlu diucapkan lebih jelas.")
    else:
        feedbacks.append("Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.")

    # Intonation feedback
    if intonation_score >= 80:
        feedbacks.append("Intonasi dan variasi nada suara Anda sangat baik, membuat presentasi menarik.")
    elif intonation_score >= 60:
        feedbacks.append("Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.")
    else:
        feedbacks.append("Hindari berbicara dengan nada monoton. Berikan penekanan pada kata-kata kunci.")

    # Sentiment / content feedback
    if sentiment_score >= 75:
        feedbacks.append("Pilihan kata dan konten presentasi terdengar profesional dan terstruktur.")
    elif sentiment_score >= 50:
        feedbacks.append("Kurangi penggunaan kata pengisi (seperti 'eh', 'um', 'anu') untuk kesan lebih profesional.")
    else:
        feedbacks.append("Perbanyak kosakata akademik dan kurangi kata-kata tidak formal dalam presentasi.")

    # Overall recommendation
    if overall_score >= 85:
        feedbacks.append("🎉 Presentasi sangat baik! Terus pertahankan kualitas ini.")
    elif overall_score >= 70:
        feedbacks.append("Presentasi sudah cukup baik. Lakukan latihan rutin untuk hasil yang lebih optimal.")
    else:
        feedbacks.append("Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.")

    return "\n".join(f"• {f}" for f in feedbacks)
