import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: GameViewModel
    let onDismiss: () -> Void
    @State private var ringProgress: Double = 0
    @State private var appeared = false
    @State private var expandedResults: Set<UUID> = []

    private var maxPossiblePoints: Int {
        viewModel.results.reduce(0) { $0 + $1.card.difficulty.points }
    }

    private var scoreRatio: Double {
        maxPossiblePoints == 0 ? 0 : Double(viewModel.score) / Double(maxPossiblePoints)
    }

    private var ringColor: Color {
        if scoreRatio >= 0.8 { return AppColors.correctGreen }
        if scoreRatio >= 0.5 { return AppColors.gold }
        return AppColors.coral
    }

    var body: some View {
        ZStack {
            AppColors.cream
                .ignoresSafeArea()

            // Warm ambient glow behind score
            Circle()
                .fill(ringColor.opacity(0.1))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(y: -120)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    scoreHeader
                    statsRow
                    roundSummary
                    actionButtons
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                ringProgress = scoreRatio
            }
            withAnimation(.easeOut(duration: 0.6)) {
                appeared = true
            }
        }
    }

    // MARK: - Score Header

    private var modeLabel: String {
        if viewModel.isDaily {
            return "Daily Challenge"
        } else if let category = viewModel.category {
            return category.rawValue
        }
        return ""
    }

    private var scoreHeader: some View {
        VStack(spacing: 16) {
            // Category / mode label
            Text(modeLabel)
                .font(.caption.weight(.bold))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
                .tracking(1.5)
                .textCase(.uppercase)

            ZStack {
                Circle()
                    .stroke(AppColors.peach, lineWidth: 8)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(viewModel.score)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)

                    Text("points")
                        .font(.caption.weight(.medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            Text(scoreMessage)
                .font(.title3.weight(.bold))
                .foregroundColor(ringColor)
        }
        .padding(.top, 40)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.9)
    }

    private var scoreMessage: String {
        if scoreRatio >= 0.8 { return "MashaAllah! Excellent!" }
        if scoreRatio >= 0.5 { return "Great job, keep learning!" }
        return "Keep it up, you'll improve!"
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(icon: "checkmark", label: "Correct", value: viewModel.correctCount, color: AppColors.correctGreen)
            StatCard(icon: "arrow.right", label: "Passed", value: viewModel.passed, color: AppColors.coral)
            StatCard(icon: "star.fill", label: "Points", value: viewModel.score, color: AppColors.gold)
        }
        .padding(.horizontal, 16)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.15), value: appeared)
    }

    // MARK: - Round Summary

    private var roundSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("ROUND SUMMARY")
                    .font(.caption.weight(.bold))
                    .foregroundColor(AppColors.textSecondary.opacity(0.6))
                    .tracking(1.5)

                Spacer()

                Text("Tap for facts")
                    .font(.caption2.weight(.medium))
                    .foregroundColor(AppColors.sage.opacity(0.6))
            }
            .padding(.horizontal, 20)

            VStack(spacing: 8) {
                ForEach(viewModel.results) { result in
                    let isCorrect = result.result == .correct
                    let isExpanded = expandedResults.contains(result.id)

                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            // Color bar
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isCorrect ? AppColors.correctGreen : AppColors.coral)
                                .frame(width: 4)
                                .padding(.vertical, 8)

                            HStack(spacing: 12) {
                                Image(systemName: isCorrect ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                                    .foregroundColor(isCorrect ? AppColors.correctGreen : AppColors.coral)
                                    .font(.body)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(result.card.text)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(AppColors.textPrimary)

                                    Text(result.card.hint)
                                        .font(.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                }

                                Spacer()

                                // Points + expand indicator
                                HStack(spacing: 6) {
                                    if isCorrect {
                                        Text("+\(result.pointsEarned)")
                                            .font(.caption.weight(.bold))
                                            .foregroundColor(AppColors.correctGreen)
                                    }

                                    Image(systemName: "chevron.down")
                                        .font(.caption2.weight(.bold))
                                        .foregroundColor(AppColors.textSecondary.opacity(0.3))
                                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                        }

                        // Expandable fun fact
                        if isExpanded && !result.card.funFact.isEmpty {
                            HStack(spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.caption)
                                    .foregroundColor(AppColors.gold)

                                Text(result.card.funFact)
                                    .font(.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)
                            .padding(.top, 2)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .softCard(cornerRadius: 14, color: AppColors.warmWhite)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if expandedResults.contains(result.id) {
                                expandedResults.remove(result.id)
                            } else {
                                expandedResults.insert(result.id)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.25), value: appeared)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                ringProgress = 0
                appeared = false
                expandedResults = []
                viewModel.showResults = false
                viewModel.startCountdown()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.body.weight(.bold))
                    Text("Play Again")
                        .font(.body.weight(.bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Capsule().fill(AppColors.accentGradient))
                .shadow(color: AppColors.coral.opacity(0.3), radius: 16, y: 6)
            }

            Button {
                onDismiss()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.body.weight(.bold))
                    Text("Switch Category")
                        .font(.body.weight(.bold))
                }
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Capsule().fill(AppColors.peach))
                .shadow(color: AppColors.textPrimary.opacity(0.06), radius: 8, y: 3)
            }

            Button {
                onDismiss()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "house.fill")
                        .font(.body.weight(.bold))
                    Text("Home")
                        .font(.body.weight(.bold))
                }
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
                .padding(.vertical, 14)
            }
        }
        .padding(.horizontal, 16)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.35), value: appeared)
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.caption.weight(.black))
                    .foregroundColor(color)
            }

            Text("\(value)")
                .font(.title3.weight(.bold))
                .foregroundColor(AppColors.textPrimary)

            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .softCard(cornerRadius: 20, color: AppColors.warmWhite)
    }
}

#Preview {
    let vm = GameViewModel(category: .prophets, duration: 60)
    vm.showResults = true
    return ResultsView(viewModel: vm) {}
}
