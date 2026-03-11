import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    init(category: GameCategory, duration: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(category: category, duration: duration))
    }

    init(dailyCards: [Card], duration: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(cards: dailyCards, duration: duration))
    }

    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()

            if viewModel.showCountdown {
                countdownOverlay
            } else if viewModel.showResults {
                ResultsView(viewModel: viewModel) {
                    dismiss()
                }
            } else if viewModel.isPlaying {
                gamePlayView
            } else {
                readyScreen
            }
        }
        .statusBarHidden(viewModel.isPlaying)
    }

    // MARK: - Background

    private var backgroundView: some View {
        ZStack {
            switch viewModel.tiltState {
            case .correct:
                LinearGradient(
                    colors: [AppColors.correctGreen.opacity(0.5), AppColors.backgroundDark],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .transition(.opacity)
            case .passed:
                LinearGradient(
                    colors: [AppColors.passRed.opacity(0.5), AppColors.backgroundDark],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .transition(.opacity)
            case .neutral:
                AppColors.backgroundGradient
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.tiltState)
    }

    // MARK: - Ready Screen (Warm / Cream)

    private var readyScreen: some View {
        ZStack {
            AppColors.cream.ignoresSafeArea()

            // Warm ambient orb
            Circle()
                .fill(AppColors.coral.opacity(0.08))
                .frame(width: 240, height: 240)
                .blur(radius: 70)
                .offset(y: -100)

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 32) {
                    ZStack {
                        Circle()
                            .fill(AppColors.coral.opacity(0.1))
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)

                        Image(systemName: "iphone.gen3")
                            .font(.system(size: 64))
                            .foregroundStyle(AppColors.accentGradient)
                            .rotationEffect(.degrees(-90))
                    }

                    VStack(spacing: 10) {
                        Text("Hold phone on your forehead")
                            .font(.title3.weight(.bold))
                            .foregroundColor(AppColors.textPrimary)

                        Text("Tap play when ready")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(36)
                .softCard(cornerRadius: 28, color: AppColors.warmWhite)
                .padding(.horizontal, 24)

                Spacer()

                HStack(spacing: 14) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.bold))
                            .foregroundColor(AppColors.textSecondary)
                            .frame(width: 58, height: 58)
                            .softCard(cornerRadius: 29, color: AppColors.warmWhite)
                    }

                    Button {
                        viewModel.startCountdown()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "play.fill")
                            Text("Play")
                                .font(.body.weight(.bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Capsule().fill(AppColors.accentGradient))
                        .shadow(color: AppColors.coral.opacity(0.3), radius: 20, y: 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 44)
            }
        }
    }

    // MARK: - Countdown

    private var countdownOverlay: some View {
        ZStack {
            AppColors.backgroundDark.opacity(0.95)
                .ignoresSafeArea()

            Text("\(viewModel.countdownValue)")
                .font(.system(size: 120, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.accentGradient)
                .scaleEffect(viewModel.countdownValue > 0 ? 1.0 : 2.0)
                .opacity(viewModel.countdownValue > 0 ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5), value: viewModel.countdownValue)
        }
    }

    // MARK: - Gameplay

    private var gamePlayView: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.top, 12)
                .padding(.horizontal, 20)

            Spacer()

            // Card — warm white for readability on forehead
            if let card = viewModel.currentCard {
                VStack(spacing: 14) {
                    // Trivia mode: prompt friends to read the question aloud
                    if isTrivia {
                        HStack(spacing: 6) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.caption2)
                            Text("Read aloud")
                                .font(.caption2.weight(.bold))
                        }
                        .foregroundColor(AppColors.triviaColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(AppColors.triviaColor.opacity(0.15)))
                    }

                    Text(card.text)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .lineLimit(3)

                    Text(card.hint)
                        .font(isTrivia ? .body.weight(.semibold) : .body.weight(.medium))
                        .foregroundColor(isTrivia ? AppColors.textPrimary.opacity(0.7) : AppColors.textSecondary)
                        .multilineTextAlignment(.center)

                    // Difficulty badge
                    Text("\(card.difficulty.label) \u{00B7} \(card.difficulty.points)pt")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(difficultyColor(card.difficulty))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(difficultyColor(card.difficulty).opacity(0.15))
                        )
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 32)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(AppColors.warmWhite)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 20, y: 8)
                .padding(.horizontal, 20)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.85).combined(with: .opacity),
                    removal: .scale(scale: 1.15).combined(with: .opacity)
                ))
                .id(card.id)
            }

            Spacer()

            tapControls
                .padding(.bottom, 28)
        }
        .overlay {
            if viewModel.isPaused {
                pauseOverlay
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            // Score pill
            HStack(spacing: 6) {
                Image(systemName: "checkmark")
                    .font(.caption.weight(.black))
                    .foregroundColor(AppColors.correctGreen)
                Text("\(viewModel.score)pt")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.gamePill)
            )

            // Streak pill (only when active)
            if viewModel.streak >= 1 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.orange)
                    Text("\(viewModel.streak)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.gamePill)
                )
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()

            // Circular timer (tap to pause/resume)
            ZStack {
                // Green glow ring on streak bonus
                if viewModel.showStreakBonus {
                    Circle()
                        .stroke(AppColors.correctGreen.opacity(0.5), lineWidth: 8)
                        .frame(width: 64, height: 64)
                        .blur(radius: 6)
                        .transition(.opacity)
                }

                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 4)
                    .frame(width: 64, height: 64)

                Circle()
                    .trim(from: 0, to: viewModel.timeProgress)
                    .stroke(
                        viewModel.showStreakBonus ? AppColors.correctGreen : timerColor,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: viewModel.timeRemaining)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.showStreakBonus)

                if viewModel.isPaused {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(timerColor)
                } else {
                    Text(timeString)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(viewModel.showStreakBonus ? AppColors.correctGreen : timerColor)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showStreakBonus)
                }

                // +3s badge anchored to timer
                if viewModel.showStreakBonus {
                    Text("+3s")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(AppColors.correctGreen))
                        .shadow(color: AppColors.correctGreen.opacity(0.6), radius: 6)
                        .offset(y: 42)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.3).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
            .scaleEffect(viewModel.showStreakBonus ? 1.15 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.5), value: viewModel.showStreakBonus)
            .contentShape(Circle())
            .onTapGesture {
                if viewModel.isPaused {
                    viewModel.resumeGame()
                } else {
                    viewModel.pauseGame()
                }
            }

            Spacer()

            // Passed pill
            HStack(spacing: 6) {
                Text("\(viewModel.passed)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Image(systemName: "arrow.right")
                    .font(.caption.weight(.black))
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.gamePill)
            )
        }
    }

    private var isTrivia: Bool {
        viewModel.category?.isQuestionBased == true
    }

    private var timerColor: Color {
        if viewModel.timeRemaining <= 5 {
            return AppColors.passRed
        } else if viewModel.timeRemaining <= 15 {
            return .orange
        }
        return AppColors.coral
    }

    private var timeString: String {
        let minutes = viewModel.timeRemaining / 60
        let seconds = viewModel.timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func difficultyColor(_ difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return AppColors.correctGreen
        case .medium: return AppColors.gold
        case .hard: return AppColors.coral
        }
    }

    // MARK: - Tap Controls

    private var tapControls: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.markPassed()
            } label: {
                VStack(spacing: 6) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                    Text("PASS")
                        .font(.caption2.weight(.bold))
                }
                .foregroundColor(.white)
                .frame(width: 90, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(AppColors.passRed.opacity(0.85))
                )
                .shadow(color: AppColors.passRed.opacity(0.3), radius: 12, y: 4)
            }

            VStack(spacing: 3) {
                Image(systemName: "arrow.up.and.down")
                    .font(.caption2)
                Text("or tilt")
                    .font(.caption2)
            }
            .foregroundColor(.white.opacity(0.25))

            Button {
                viewModel.markCorrect()
            } label: {
                VStack(spacing: 6) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                    Text("CORRECT")
                        .font(.caption2.weight(.bold))
                }
                .foregroundColor(.white)
                .frame(width: 90, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(AppColors.correctGreen.opacity(0.85))
                )
                .shadow(color: AppColors.correctGreen.opacity(0.3), radius: 12, y: 4)
            }
        }
    }

    // MARK: - Pause Overlay (Warm / Cream)

    private var pauseOverlay: some View {
        ZStack {
            AppColors.cream.opacity(0.97)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("Paused")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(AppColors.textPrimary)

                VStack(spacing: 12) {
                    Button {
                        viewModel.resumeGame()
                    } label: {
                        Label("Resume", systemImage: "play.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 200)
                            .padding(.vertical, 16)
                            .background(Capsule().fill(AppColors.accentGradient))
                            .shadow(color: AppColors.coral.opacity(0.3), radius: 16, y: 6)
                    }

                    Button {
                        viewModel.endGame()
                    } label: {
                        Label("End Game", systemImage: "stop.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(AppColors.textSecondary)
                            .frame(width: 200)
                            .padding(.vertical, 16)
                            .background(Capsule().fill(AppColors.peach))
                            .shadow(color: AppColors.textPrimary.opacity(0.06), radius: 8, y: 3)
                    }

                    Button {
                        dismiss()
                    } label: {
                        Label("Home", systemImage: "house.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(AppColors.textSecondary.opacity(0.6))
                            .frame(width: 200)
                            .padding(.vertical, 16)
                    }
                }
            }
        }
    }
}

#Preview {
    GameView(category: .prophets, duration: 60)
}
