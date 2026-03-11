import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: GameCategory?
    @State private var selectedTimer: TimerOption = .sixty
    @State private var navigateToGame = false
    @State private var navigateToDaily = false
    @State private var showHowToPlay = false

    private let dailyChallenge = DailyChallenge()

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.cream.ignoresSafeArea()

                // Warm ambient blobs
                ambientOrbs.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        header
                        dailyChallengeCard
                        categoryGrid
                        timerSelection
                        startButton
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $navigateToGame) {
                if let category = selectedCategory {
                    GameView(category: category, duration: selectedTimer.rawValue)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .navigationDestination(isPresented: $navigateToDaily) {
                GameView(dailyCards: dailyChallenge.cards, duration: DailyChallenge.duration)
                    .navigationBarBackButtonHidden(true)
            }
            .sheet(isPresented: $showHowToPlay) {
                howToPlaySheet
            }
        }
    }

    // MARK: - Ambient Orbs

    private var ambientOrbs: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(AppColors.coral.opacity(0.08))
                    .frame(width: 280, height: 280)
                    .blur(radius: 80)
                    .offset(x: -geo.size.width * 0.3, y: -geo.size.height * 0.1)

                Circle()
                    .fill(AppColors.sage.opacity(0.08))
                    .frame(width: 220, height: 220)
                    .blur(radius: 70)
                    .offset(x: geo.size.width * 0.35, y: geo.size.height * 0.15)

                Circle()
                    .fill(AppColors.conceptsColor.opacity(0.06))
                    .frame(width: 180, height: 180)
                    .blur(radius: 60)
                    .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.55)
            }
        }
    }

    // MARK: - Header

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Assalamu Alaikum" }
        if hour < 17 { return "Assalamu Alaikum" }
        return "Assalamu Alaikum"
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(greeting)
                        .font(.caption.weight(.medium))
                        .foregroundColor(AppColors.textSecondary)
                    Text("DeenUp!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.accentGradient)
                }

                Spacer()

                Button {
                    showHowToPlay = true
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(AppColors.sage)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Daily Challenge Card

    private var dailyChallengeCard: some View {
        Button {
            navigateToDaily = true
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.gold.opacity(0.15))
                        .frame(width: 52, height: 52)

                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(AppColors.gold)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Challenge")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)

                    Text("\(dailyChallenge.dateString) \u{00B7} \(DailyChallenge.cardCount) cards \u{00B7} \(DailyChallenge.duration)s")
                        .font(.caption.weight(.medium))
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(AppColors.gold.opacity(0.6))
            }
            .padding(16)
            .softCard(cornerRadius: 20, color: AppColors.warmWhite)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Category Grid

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("CATEGORY")
                .font(.caption.weight(.bold))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
                .tracking(1.5)
                .padding(.horizontal, 20)

            categoryRows
                .padding(.horizontal, 16)
        }
    }

    private var categoryRows: some View {
        let categories = GameCategory.allCases
        let paired = stride(from: 0, to: categories.count - 1, by: 2)

        return VStack(spacing: 14) {
            ForEach(Array(paired), id: \.self) { i in
                HStack(spacing: 14) {
                    categoryTile(categories[i])
                    if i + 1 < categories.count {
                        categoryTile(categories[i + 1])
                    }
                }
            }

            // Odd last card — full width
            if categories.count.isMultiple(of: 2) == false {
                categoryTile(categories[categories.count - 1])
            }
        }
    }

    private func categoryTile(_ category: GameCategory) -> some View {
        CategoryCard(
            category: category,
            isSelected: selectedCategory == category
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedCategory = category
            }
        }
    }

    // MARK: - Timer Selection

    private var timerSelection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("DURATION")
                .font(.caption.weight(.bold))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
                .tracking(1.5)
                .padding(.horizontal, 20)

            HStack(spacing: 10) {
                ForEach(TimerOption.allCases) { option in
                    TimerPill(option: option, isSelected: selectedTimer == option)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTimer = option
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Start Button

    private var startButton: some View {
        Button {
            if selectedCategory != nil {
                navigateToGame = true
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "play.fill")
                    .font(.body.weight(.bold))
                Text("Start Game")
                    .font(.body.weight(.bold))
            }
            .foregroundColor(selectedCategory != nil ? .white : AppColors.textSecondary.opacity(0.4))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Capsule().fill(selectedCategory != nil ? AnyShapeStyle(AppColors.accentGradient) : AnyShapeStyle(AppColors.peach))
            )
            .shadow(color: selectedCategory != nil ? AppColors.coral.opacity(0.3) : .clear, radius: 16, y: 6)
        }
        .disabled(selectedCategory == nil)
        .padding(.horizontal, 16)
    }

    // MARK: - How to Play Sheet

    private var howToPlaySheet: some View {
        ZStack {
            AppColors.cream.ignoresSafeArea()

            VStack(spacing: 28) {
                Capsule()
                    .fill(AppColors.textSecondary.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)

                Text("How to Play")
                    .font(.title2.weight(.bold))
                    .foregroundColor(AppColors.textPrimary)

                VStack(spacing: 16) {
                    HowToPlayRow(icon: "iphone.gen3", text: "Hold phone on your forehead", step: 1)
                    HowToPlayRow(icon: "person.2.fill", text: "Friends give clues, you guess", step: 2)
                    HowToPlayRow(icon: "arrow.down", text: "Nod forward or tap \u{2713} if correct", step: 3)
                    HowToPlayRow(icon: "arrow.up", text: "Tilt back or tap \u{2717} to pass", step: 4)
                }
                .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(AppColors.coral)
                        Text("3 correct in a row = +3 bonus seconds!")
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.gold)
                        Text("Harder cards earn more points")
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "questionmark.bubble.fill")
                            .foregroundColor(AppColors.triviaColor)
                        Text("In Trivia, friends read the question aloud")
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.hidden)
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: GameCategory
    let isSelected: Bool

    private var catColor: Color {
        AppColors.categoryColor(for: category)
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(catColor.opacity(isSelected ? 0.25 : 0.12))
                    .frame(width: 52, height: 52)

                Image(systemName: category.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(catColor)
            }

            VStack(spacing: 4) {
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.textPrimary)

                Text("\(category.cards.count) cards")
                    .font(.caption2.weight(.medium))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(catColor.opacity(0.08)))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .softCard(cornerRadius: 20, color: isSelected ? catColor.opacity(0.1) : AppColors.warmWhite)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? catColor.opacity(0.4) : .clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.03 : 1.0)
    }
}

// MARK: - Timer Pill

struct TimerPill: View {
    let option: TimerOption
    let isSelected: Bool

    var body: some View {
        Text(option.label)
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(isSelected ? .white : AppColors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Capsule().fill(isSelected ? AnyShapeStyle(AppColors.accentGradient) : AnyShapeStyle(AppColors.warmWhite))
            )
            .shadow(color: isSelected ? AppColors.coral.opacity(0.2) : AppColors.textPrimary.opacity(0.04), radius: 8, y: 3)
    }
}

// MARK: - How to Play Row

struct HowToPlayRow: View {
    let icon: String
    let text: String
    let step: Int

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.sage.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.sage)
            }

            Text(text)
                .font(.body.weight(.medium))
                .foregroundColor(AppColors.textPrimary.opacity(0.8))

            Spacer()
        }
        .padding(14)
        .softCard(cornerRadius: 16, color: AppColors.warmWhite)
    }
}

#Preview {
    HomeView()
}
