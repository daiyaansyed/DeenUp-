import Foundation

struct DailyChallenge {
    let cards: [Card]
    let dateString: String

    static let cardCount = 15
    static let duration = 60

    init(date: Date = Date()) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)

        // Format display date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        self.dateString = formatter.string(from: startOfDay)

        // Use day offset from reference date as seed for deterministic shuffle
        let daysSinceReference = Int(startOfDay.timeIntervalSinceReferenceDate / 86400)
        var rng = SeededRandomNumberGenerator(seed: UInt64(daysSinceReference))

        // Gather all cards from all categories
        var allCards: [Card] = []
        for category in GameCategory.allCases {
            allCards.append(contentsOf: category.cards)
        }

        // Deterministic shuffle and pick first N
        allCards.shuffle(using: &rng)
        self.cards = Array(allCards.prefix(Self.cardCount))
    }
}

// MARK: - Seeded RNG

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // xorshift64
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
