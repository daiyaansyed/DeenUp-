<p align="center">
  <img src="assets/App_Icon_Dark_Mode.png" width="120" alt="DeenUp Logo">
</p>

<h1 align="center">DeenUp!</h1>
<p align="center"><strong>The party game for the ummah 🕌</strong></p>

<p align="center">
  A Heads Up-style party game built for Muslims. Hold the phone to your forehead, guess the answer, and race the clock — all while learning about your deen.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS-blue" alt="Platform">
  <img src="https://img.shields.io/badge/swift-5.9-orange" alt="Swift">
  <img src="https://img.shields.io/badge/swiftui-✓-green" alt="SwiftUI">
  <img src="https://img.shields.io/badge/license-MIT-lightgrey" alt="License">
  <img src="https://img.shields.io/github/stars/YOUR_USERNAME/DeenUp?style=social" alt="Stars">
</p>

<p align="center">
  <img src="assets/demo.gif" width="300" alt="DeenUp gameplay demo">
</p>

---

## What is DeenUp?

DeenUp is an open-source Islamic party game for iPhone. It brings the fun of Heads Up to Muslim gatherings — iftars, family nights, halaqahs, Eid parties, and beyond. Built entirely with SwiftUI and AI (Claude by Anthropic).

---

## Screenshots

<p align="center">
  <img src="assets/screenshot-home.png" width="180" alt="Home Screen">
  &nbsp;&nbsp;
  <img src="assets/screenshot-gameplay.png" width="180" alt="Gameplay">
  &nbsp;&nbsp;
  <img src="assets/screenshot-trivia.png" width="180" alt="Trivia Mode">
  &nbsp;&nbsp;
  <img src="assets/screenshot-results.png" width="180" alt="Results">
</p>

---

## Game Modes

### 🎭 Charades Mode
Your friends give you clues — you guess the word on the screen.

1. Pick a category
2. Hold the phone to your forehead
3. Your friends shout clues, act, or describe
4. Tilt down or tap ✓ if correct
5. Tilt back or tap ✗ to pass
6. Guess as many as you can before time runs out

### 🧠 Islamic Trivia Mode
Your friends read the question — you answer it.

1. Pick Islamic Trivia
2. Hold the phone to your forehead
3. A friend reads the question aloud (e.g. "Who was the Quran revealed to?")
4. You answer out loud
5. Tilt down or tap ✓ if correct, tilt back or tap ✗ to pass

---

## Categories

| Category | Cards | Mode | Description |
|----------|-------|------|-------------|
| 🌟 Prophets | 25 | Charades | From Adam (AS) to Muhammad (SAW) |
| 👥 Sahaba | 25 | Charades | The Companions of the Prophet (SAW) |
| 📖 Surahs & Quran | 25 | Charades | Surahs, ayahs, and Quranic concepts |
| 💡 Islamic Terms | 30 | Charades | Key concepts like Tawhid, Taqwa, Hajj |
| 🧠 Islamic Trivia | 25 | Trivia | Questions read aloud — you answer |
| | **130 total** | | |

---

## Features

- **Two game modes** — Charades and Trivia for variety
- **5 categories, 130 cards** — each with helpful hints
- **Tilt + tap controls** — use motion gestures or on-screen buttons
- **Customizable timer** — 60s, 90s, or 120s per round
- **3-2-1 countdown** — get ready before the round starts
- **Haptic feedback** — feel every correct and passed answer
- **Pause & resume** — take a break mid-round
- **Results screen** — full round summary with score breakdown
- **No ads. No tracking. No subscriptions.** — just deen and fun

---

## Tech Stack

- **SwiftUI** — 100% declarative UI
- **CoreMotion** — tilt detection for hands-free gameplay
- **AVFoundation** — sound and haptics
- **Built with AI** — designed with Claude.ai, coded with Claude Code by Anthropic

---

## Getting Started

### Requirements
- Xcode 15+
- iOS 17+
- iPhone (tilt gestures require a physical device)

### Installation

1. Clone the repo:
```bash
git clone https://github.com/YOUR_USERNAME/DeenUp.git
cd DeenUp
```

2. Open in Xcode:
```bash
open DeenUp.xcodeproj
```

3. Add Motion permission to `Info.plist`:
```
Privacy - Motion Usage Description: "Used to detect tilt gestures during gameplay"
```

4. Select your device or simulator and hit **Run** (⌘R)

---

## Coming Soon 🚀

DeenUp is launching on the App Store soon. Star this repo to stay updated!

---

## Contributing

**DeenUp isn't my app — it's the ummah's app.** I built the foundation, but it's the community that will make it special. Contributions are welcome and encouraged.

### Ways to contribute

**🃏 Add new categories**
- Create a new set of cards in `Models.swift`
- Follow the existing format: each card needs a `text` and a `hint`
- Suggested categories: Islamic history, daily duas, names of Allah, fiqh, halal food, Ramadan, Muslim countries, notable scholars

**🌍 Translate into your language**
We want every Muslim family to play in their language. Translations are needed for:

| Language | Status |
|----------|--------|
| Arabic (العربية) | 🔲 Needed |
| Urdu (اردو) | 🔲 Needed |
| Bahasa Melayu | 🔲 Needed |
| Turkish (Türkçe) | 🔲 Needed |
| French (Français) | 🔲 Needed |
| Somali (Soomaali) | 🔲 Needed |
| Bengali (বাংলা) | 🔲 Needed |
| Indonesian | 🔲 Needed |
| Hindi (हिंदी) | 🔲 Needed |
| Spanish (Español) | 🔲 Needed |

Want to help translate? Open an issue titled `Translation: [Language]` and we'll coordinate.

**🎨 Improve the design**
- UI/UX improvements
- Animations and transitions
- Dark mode refinements
- Accessibility improvements

**🛠️ Add features**
- Multiplayer / team scoring
- Sound effects and audio
- Difficulty levels
- Custom deck builder
- Score history and stats
- iPad support

**🐛 Fix bugs**
- Open an issue with steps to reproduce
- Submit a PR with the fix

### How to submit a contribution

1. Fork this repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test on a device (tilt gestures don't work on simulator)
5. Commit: `git commit -m "Add: your feature description"`
6. Push: `git push origin feature/your-feature`
7. Open a Pull Request

---

## Project Structure

```
DeenUp/
├── IslamHeadsUpApp.swift    # App entry point
├── Models.swift             # Cards data, categories, game models
├── GameViewModel.swift      # Game logic, timer, motion detection
├── HomeView.swift           # Category selection & settings
├── GameView.swift           # Main gameplay screen
├── ResultsView.swift        # End-of-round results
└── assets/                  # Logo, screenshots, demo GIF
```

---

## Feedback

Played a round? I'd love to hear from you:

- **What categories should we add?**
- **Which mode is more fun — Charades or Trivia?**
- **Would you play this at your next gathering?**

Open an issue, start a discussion, or reach out on [Twitter/X](https://twitter.com/YOUR_HANDLE) or [LinkedIn](https://linkedin.com/in/YOUR_HANDLE).

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Acknowledgements

- Built with [Claude](https://claude.ai) by [Anthropic](https://anthropic.com)
- Inspired by [Heads Up!](https://apps.apple.com/us/app/heads-up/id623592465) by Ellen DeGeneres
- Made with love for the ummah 🤲

---

<p align="center">
  <strong>Star ⭐ this repo if you want to see DeenUp on the App Store!</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/YOUR_USERNAME/DeenUp?style=social" alt="Stars">
</p>
