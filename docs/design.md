# Project: AI-Based Speech Evaluation System (AssessAI)

## Global Design Constraints
- **Color Palette:** Strictly Monochromatic.
  - Background: Pure White (#FFFFFF)
  - Primary Text: Deep Black (#000000)
  - Secondary Text/Icons: Dark Gray (#4B5563)
  - Borders/Dividers: Light Gray (#E5E7EB)
  - Surfaces/Cards: Off-White or Very Light Gray (#F9FAFB)
- **Typography:** Sans-serif (Inter or Geist), clean, high readability.
- **Style:** Minimalist, Flat UI, thin borders (1px), subtle shadows only.

## Pages & Components Structure

### 1. Authentication Page (Login/Register)
- **Layout:** Centered minimalist card.
- **Components:**
  - App Logo (Abstract geometric shape in black).
  - Input fields with thin black borders.
  - Primary Button: Solid Black with White Text.
  - Secondary Button: White with Black Border.

### 2. Student Dashboard (Overview)
- **Navigation:** Sidebar (Black background, white text) or Top-bar (White background, black bottom border).
- **Components:**
  - **Welcome Section:** Large bold greeting.
  - **Stats Cards:** Total practices, Average Score, Last Improvement (shown in grayscale shades).
  - **Recent Activity Table:** List of previous recordings with date, score, and a "View" button.
  - **Floating Action Button:** "New Practice" (Solid Black).

### 3. Upload & Processing Page (The "Action" Page)
- **Components:**
  - **Dropzone:** Large dashed border area (Light Gray) with an "Upload Audio" icon.
  - **File Validation:** Small text indicating supported formats (.wav, .mp3).
  - **Progress State:** A minimalist thin black loading bar that pulses while the CNN-LSTM model is "Processing...".
  - **Cancel Button:** Simple underlined text.

### 4. Result & Analysis Page (AI Feedback)
- **Components:**
  - **Overall Score:** Large numerical display (e.g., 85/100) in bold black.
  - **Analysis Grid:** 
    - **Emotion Detection:** Bar chart (Grayscale: darkest gray for highest probability).
    - **Articulation & Intonasi:** Gauge or simple linear progress bar.
  - **AI Suggestions:** A text box with a light gray background containing bullet points for improvement.
  - **Waveform Display:** A black line-art representation of the analyzed audio.

### 5. Lecturer Dashboard (Monitoring & Recap)
- **Components:**
  - **Class Selector:** Dropdown menu to pick specific classes.
  - **Student List Table:** 
    - Columns: Name, NIM, Latest Score, Trend (Arrow icons: up/down/flat in black).
    - Action: "Download PDF Recap" (Outline button).
  - **Global Analytics:** A line chart showing the class average progress over time.

### 6. Settings & Profile
- **Components:**
  - User info editor.
  - Dark mode toggle (strictly grayscale).
  - Logout button (Text only, subtle gray).

## Interaction Cues
- **Hover State:** Button background changes from Black to Dark Gray, or White to Light Gray.
- **Active State:** Bold black underline for active navigation items.
- **Empty State:** Simple minimalist illustrations in thin gray lines.