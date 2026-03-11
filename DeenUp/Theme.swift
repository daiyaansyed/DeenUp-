import SwiftUI

// MARK: - Color Palette

enum AppColors {
    // Backgrounds
    static let cream = Color(red: 0.99, green: 0.96, blue: 0.93)             // #FDF6EC
    static let peach = Color(red: 0.98, green: 0.91, blue: 0.83)             // #FAE8D4
    static let warmWhite = Color(red: 1.0, green: 0.97, blue: 0.94)          // #FFF8F0
    static let gameDark = Color(red: 0.12, green: 0.16, blue: 0.23)          // #1E2A3A

    // Text
    static let textPrimary = Color(red: 0.18, green: 0.13, blue: 0.09)       // #2D2016
    static let textSecondary = Color(red: 0.55, green: 0.45, blue: 0.33)     // #8B7355

    // Accents
    static let coral = Color(red: 0.91, green: 0.45, blue: 0.29)             // #E8734A
    static let sage = Color(red: 0.49, green: 0.71, blue: 0.62)              // #7CB69D
    static let gold = Color(red: 0.83, green: 0.58, blue: 0.30)              // #D4944C

    // Category colors (muted & warm)
    static let prophetsColor = Color(red: 0.48, green: 0.69, blue: 0.80)     // #7BAFCB soft sky blue
    static let sahabaColor = Color(red: 0.49, green: 0.71, blue: 0.62)       // #7CB69D sage green
    static let quranColor = Color(red: 0.83, green: 0.58, blue: 0.30)        // #D4944C warm amber
    static let conceptsColor = Color(red: 0.65, green: 0.53, blue: 0.77)     // #A688C4 muted lavender
    static let triviaColor = Color(red: 0.80, green: 0.52, blue: 0.52)      // #CC8585 dusty rose

    // Semantic
    static let correctGreen = Color(red: 0.42, green: 0.75, blue: 0.48)      // #6BBF7B
    static let passRed = Color(red: 0.83, green: 0.45, blue: 0.42)           // #D4736C warm rose

    // Gameplay (dark screen)
    static let backgroundDark = gameDark
    static let backgroundGradient = LinearGradient(
        colors: [gameDark, Color(red: 0.08, green: 0.11, blue: 0.17)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let gameCardFill = Color(red: 0.18, green: 0.22, blue: 0.30)      // soft dark card fill
    static let gamePill = Color(red: 0.16, green: 0.20, blue: 0.28)          // pill bg on dark screen

    // Gradients
    static let accentGradient = LinearGradient(
        colors: [coral, Color(red: 0.90, green: 0.55, blue: 0.30)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func categoryColor(for category: GameCategory) -> Color {
        switch category {
        case .prophets: return prophetsColor
        case .sahaba: return sahabaColor
        case .quran: return quranColor
        case .concepts: return conceptsColor
        case .trivia: return triviaColor
        }
    }
}

// MARK: - Soft Card Modifier

struct SoftCard: ViewModifier {
    var cornerRadius: CGFloat = 24
    var color: Color = AppColors.peach

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            )
            .shadow(color: AppColors.textPrimary.opacity(0.06), radius: 12, y: 4)
    }
}

extension View {
    func softCard(cornerRadius: CGFloat = 24, color: Color = AppColors.peach) -> some View {
        modifier(SoftCard(cornerRadius: cornerRadius, color: color))
    }
}
