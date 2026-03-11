import SwiftUI
import Combine
import CoreMotion
import AVFoundation

// MARK: - Game ViewModel

class GameViewModel: ObservableObject {
    @Published var currentCard: Card?
    @Published var timeRemaining: Int
    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var results: [RoundResult] = []
    @Published var showResults = false
    @Published var tiltState: TiltState = .neutral
    @Published var showCountdown = false
    @Published var countdownValue = 3
    @Published var streak: Int = 0
    @Published var showStreakBonus = false

    enum TiltState {
        case neutral, correct, passed
    }

    let category: GameCategory?
    let totalTime: Int
    let isDaily: Bool

    private var cards: [Card] = []
    private var cardIndex = 0
    private var timer: Timer?
    private var countdownTimer: Timer?
    private let motionManager = CMMotionManager()
    private var isTiltEnabled = true
    private var lastTiltAction: Date = .distantPast
    private let tiltCooldown: TimeInterval = 1.0

    // Sound effects
    private var correctSound: AVAudioPlayer?
    private var passSound: AVAudioPlayer?
    private var tickSound: AVAudioPlayer?

    // Category-based init
    init(category: GameCategory, duration: Int) {
        self.category = category
        self.totalTime = duration
        self.timeRemaining = duration
        self.isDaily = false
        self.cards = category.cards.shuffled()
        loadNextCard()
    }

    // Daily challenge init (raw cards)
    init(cards: [Card], duration: Int) {
        self.category = nil
        self.totalTime = duration
        self.timeRemaining = duration
        self.isDaily = true
        self.cards = cards
        loadNextCard()
    }

    // MARK: - Game Flow

    func startCountdown() {
        showCountdown = true
        countdownValue = 3

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.countdownValue -= 1
                if self.countdownValue <= 0 {
                    self.countdownTimer?.invalidate()
                    self.showCountdown = false
                    self.startGame()
                }
            }
        }
    }

    func startGame() {
        isPlaying = true
        timeRemaining = totalTime
        results = []
        streak = 0
        cardIndex = 0
        if let category = category {
            cards = category.cards.shuffled()
        } else {
            cards.shuffle()
        }
        loadNextCard()
        startTimer()
        startMotionDetection()
    }

    func pauseGame() {
        isPaused = true
        timer?.invalidate()
        stopMotionDetection()
    }

    func resumeGame() {
        isPaused = false
        startTimer()
        startMotionDetection()
    }

    func endGame() {
        isPlaying = false
        timer?.invalidate()
        stopMotionDetection()
        showResults = true
    }

    // MARK: - Card Actions

    func markCorrect() {
        guard let card = currentCard else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            tiltState = .correct
        }
        results.append(RoundResult(card: card, result: .correct, pointsEarned: card.difficulty.points))
        streak += 1
        hapticFeedback(style: .success)

        // Streak bonus: +3s every 3 correct in a row
        if streak > 0 && streak % 3 == 0 {
            timeRemaining += 3
            hapticFeedback(style: .streakBonus)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                showStreakBonus = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                withAnimation { self?.showStreakBonus = false }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tiltState = .neutral
            self?.loadNextCard()
        }
    }

    func markPassed() {
        guard let card = currentCard else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            tiltState = .passed
        }
        results.append(RoundResult(card: card, result: .passed, pointsEarned: 0))
        streak = 0
        hapticFeedback(style: .warning)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tiltState = .neutral
            self?.loadNextCard()
        }
    }

    // MARK: - Private Methods

    private func loadNextCard() {
        if cardIndex < cards.count {
            currentCard = cards[cardIndex]
            cardIndex += 1
        } else {
            // Reshuffle if we run out
            cards.shuffle()
            cardIndex = 0
            currentCard = cards[cardIndex]
            cardIndex += 1
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    if self.timeRemaining <= 5 && self.timeRemaining > 0 {
                        self.hapticFeedback(style: .light)
                    }
                } else {
                    self.endGame()
                }
            }
        }
    }

    private func startMotionDetection() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.1

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self,
                  let motion = motion,
                  self.isTiltEnabled,
                  !self.isPaused,
                  Date().timeIntervalSince(self.lastTiltAction) > self.tiltCooldown
            else { return }

            // Use gravity vector for Heads Up-style tilt detection.
            // Phone is held on forehead in portrait, screen facing outward.
            // Neutral (vertical): gravity.z ≈ 0
            // Nod forward (correct): gravity.z goes negative (screen faces floor)
            // Tilt backward (pass): gravity.z goes positive (screen faces ceiling)
            let gz = motion.gravity.z
            let threshold = 0.55

            if gz < -threshold {
                self.lastTiltAction = Date()
                self.markCorrect()
            } else if gz > threshold {
                self.lastTiltAction = Date()
                self.markPassed()
            }
        }
    }

    private func stopMotionDetection() {
        motionManager.stopDeviceMotionUpdates()
    }

    private func hapticFeedback(style: HapticStyle) {
        switch style {
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .streakBonus:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred(intensity: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                generator.impactOccurred(intensity: 0.7)
            }
        }
    }

    enum HapticStyle {
        case success, warning, light, streakBonus
    }

    // MARK: - Computed Properties

    var score: Int {
        results.reduce(0) { $0 + $1.pointsEarned }
    }

    var correctCount: Int {
        results.filter { $0.result == .correct }.count
    }

    var passed: Int {
        results.filter { $0.result == .passed }.count
    }

    var timeProgress: Double {
        Double(timeRemaining) / Double(totalTime)
    }

    deinit {
        timer?.invalidate()
        countdownTimer?.invalidate()
        stopMotionDetection()
    }
}
