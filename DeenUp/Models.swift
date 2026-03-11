import Foundation

// MARK: - Difficulty

enum Difficulty: String, Codable {
    case easy, medium, hard

    var points: Int {
        switch self {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        }
    }

    var label: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}

// MARK: - Models

struct Card: Identifiable, Codable {
    let id: UUID
    let text: String
    let hint: String
    let difficulty: Difficulty
    let funFact: String

    init(text: String, hint: String, difficulty: Difficulty = .medium, funFact: String = "") {
        self.id = UUID()
        self.text = text
        self.hint = hint
        self.difficulty = difficulty
        self.funFact = funFact
    }
}

enum CardResult {
    case correct
    case passed
}

struct RoundResult: Identifiable {
    let id = UUID()
    let card: Card
    let result: CardResult
    let pointsEarned: Int
}

// MARK: - Categories

enum GameCategory: String, CaseIterable, Identifiable {
    case prophets = "Prophets"
    case sahaba = "Sahaba"
    case quran = "Surahs & Quran"
    case concepts = "Islamic Terms"
    case trivia = "Islamic Trivia"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .prophets: return "star.fill"
        case .sahaba: return "person.3.fill"
        case .quran: return "book.fill"
        case .concepts: return "lightbulb.fill"
        case .trivia: return "questionmark.bubble.fill"
        }
    }

    var color: String {
        switch self {
        case .prophets: return "prophetsColor"
        case .sahaba: return "sahabaColor"
        case .quran: return "quranColor"
        case .concepts: return "conceptsColor"
        case .trivia: return "triviaColor"
        }
    }

    /// Whether this category uses a question-and-answer format (friends read the hint aloud as a question).
    var isQuestionBased: Bool {
        self == .trivia
    }

    var cards: [Card] {
        switch self {
        case .prophets: return Self.prophetsCards
        case .sahaba: return Self.sahabaCards
        case .quran: return Self.quranCards
        case .concepts: return Self.conceptsCards
        case .trivia: return Self.triviaCards
        }
    }

    // MARK: - Prophets Cards
    static let prophetsCards: [Card] = [
        Card(text: "Adam (AS)", hint: "The first human and prophet", difficulty: .easy,
             funFact: "Adam is mentioned 25 times in the Quran. Allah taught him the names of all things."),
        Card(text: "Nuh (AS)", hint: "Built the Ark", difficulty: .easy,
             funFact: "Nuh preached to his people for 950 years. His story is told in Surah Nuh (Chapter 71)."),
        Card(text: "Ibrahim (AS)", hint: "Friend of Allah, built the Ka'bah", difficulty: .easy,
             funFact: "Ibrahim is called Khalilullah (Friend of Allah) and is considered the father of monotheism."),
        Card(text: "Ismail (AS)", hint: "Son of Ibrahim, nearly sacrificed", difficulty: .medium,
             funFact: "The act of sacrifice during Eid al-Adha commemorates Ibrahim's willingness to sacrifice Ismail."),
        Card(text: "Ishaq (AS)", hint: "Son of Ibrahim and Sarah", difficulty: .medium,
             funFact: "Ishaq was born to Sarah when she was elderly, a miracle from Allah."),
        Card(text: "Yaqub (AS)", hint: "Also known as Israel", difficulty: .medium,
             funFact: "Yaqub had 12 sons, and the tribes of Israel are named after them."),
        Card(text: "Yusuf (AS)", hint: "Known for his beauty, thrown in a well", difficulty: .easy,
             funFact: "Surah Yusuf is the only surah that tells a complete story from beginning to end."),
        Card(text: "Musa (AS)", hint: "Spoke to Allah, parted the sea", difficulty: .easy,
             funFact: "Musa is the most frequently mentioned prophet in the Quran, appearing over 130 times."),
        Card(text: "Harun (AS)", hint: "Brother of Musa", difficulty: .medium,
             funFact: "Harun was known for his eloquence and was appointed to assist Musa in his mission."),
        Card(text: "Dawud (AS)", hint: "Given the Zabur (Psalms)", difficulty: .medium,
             funFact: "Dawud could soften iron with his bare hands and birds would join him in praising Allah."),
        Card(text: "Sulayman (AS)", hint: "Could speak to animals and jinn", difficulty: .medium,
             funFact: "Sulayman commanded jinn, animals, and the wind, and had the most powerful kingdom ever."),
        Card(text: "Ayyub (AS)", hint: "Known for his patience in suffering", difficulty: .medium,
             funFact: "Ayyub endured severe illness for years but never complained, becoming the symbol of patience."),
        Card(text: "Yunus (AS)", hint: "Swallowed by a whale", difficulty: .easy,
             funFact: "Yunus's supplication from inside the whale is one of the most powerful duas in Islam."),
        Card(text: "Isa (AS)", hint: "Born to Maryam without a father", difficulty: .easy,
             funFact: "Isa spoke as an infant in the cradle to defend his mother Maryam's honor."),
        Card(text: "Muhammad (SAW)", hint: "The final messenger", difficulty: .easy,
             funFact: "Muhammad received the first revelation at age 40 in the Cave of Hira during Ramadan."),
        Card(text: "Idris (AS)", hint: "Raised to a high station", difficulty: .hard,
             funFact: "Idris is believed to be one of the earliest prophets and was known for his wisdom and knowledge."),
        Card(text: "Hud (AS)", hint: "Sent to the people of 'Ad", difficulty: .hard,
             funFact: "The people of 'Ad were giants who built magnificent structures but were destroyed by a fierce wind."),
        Card(text: "Salih (AS)", hint: "Sent to the people of Thamud, miracle of the she-camel", difficulty: .hard,
             funFact: "The she-camel of Salih miraculously emerged from a rock as proof of his prophethood."),
        Card(text: "Lut (AS)", hint: "Nephew of Ibrahim, sent to Sodom", difficulty: .medium,
             funFact: "Lut's story warns against moral corruption. His people's city was completely overturned."),
        Card(text: "Shuayb (AS)", hint: "Sent to the people of Madyan", difficulty: .hard,
             funFact: "Shuayb is known as the 'Orator of the Prophets' for his eloquent speech."),
        Card(text: "Zakariya (AS)", hint: "Father of Yahya, caretaker of Maryam", difficulty: .medium,
             funFact: "Zakariya was blessed with a son Yahya at a very old age after earnest supplication."),
        Card(text: "Yahya (AS)", hint: "Known as John, son of Zakariya", difficulty: .medium,
             funFact: "Yahya was given wisdom as a child and was known for his compassion and piety."),
        Card(text: "Ilyas (AS)", hint: "Sent to the people who worshipped Baal", difficulty: .hard,
             funFact: "Ilyas called his people away from idol worship of Baal, a sun deity."),
        Card(text: "Al-Yasa (AS)", hint: "Successor of Ilyas", difficulty: .hard,
             funFact: "Al-Yasa continued the mission of Ilyas and is praised in the Quran among the chosen."),
        Card(text: "Dhul-Kifl (AS)", hint: "Known for fulfilling his promises", difficulty: .hard,
             funFact: "Dhul-Kifl is praised in the Quran for his patience and is counted among the righteous."),
    ]

    // MARK: - Sahaba Cards
    static let sahabaCards: [Card] = [
        Card(text: "Abu Bakr (RA)", hint: "The first Caliph and closest companion", difficulty: .easy,
             funFact: "Abu Bakr spent his entire fortune for Islam and was the Prophet's companion in the cave during Hijrah."),
        Card(text: "Umar ibn Al-Khattab (RA)", hint: "The second Caliph, known for justice", difficulty: .easy,
             funFact: "Umar's conversion to Islam strengthened the Muslim community so much that they could pray openly at the Ka'bah."),
        Card(text: "Uthman ibn Affan (RA)", hint: "The third Caliph, compiled the Quran", difficulty: .easy,
             funFact: "Uthman standardized the Quran into one unified text and distributed copies across the Muslim world."),
        Card(text: "Ali ibn Abi Talib (RA)", hint: "The fourth Caliph, cousin of the Prophet", difficulty: .easy,
             funFact: "Ali was the first child to accept Islam and slept in the Prophet's bed during the night of Hijrah."),
        Card(text: "Khadijah (RA)", hint: "First wife of the Prophet and first to accept Islam", difficulty: .easy,
             funFact: "Khadijah was a successful businesswoman who proposed to the Prophet and supported him throughout his mission."),
        Card(text: "Aisha (RA)", hint: "Wife of the Prophet, great scholar", difficulty: .easy,
             funFact: "Aisha narrated over 2,200 hadiths and was consulted by companions on matters of Islamic law."),
        Card(text: "Bilal ibn Rabah (RA)", hint: "The first muezzin (caller to prayer)", difficulty: .easy,
             funFact: "Bilal was freed from slavery by Abu Bakr and his voice calling the adhan moved people to tears."),
        Card(text: "Hamza (RA)", hint: "Uncle of the Prophet, Lion of Allah", difficulty: .medium,
             funFact: "Hamza was one of the bravest warriors in Islam and was martyred at the Battle of Uhud."),
        Card(text: "Khalid ibn Al-Walid (RA)", hint: "Sword of Allah, undefeated general", difficulty: .medium,
             funFact: "Khalid never lost a single battle in his military career, earning the title 'Sword of Allah'."),
        Card(text: "Salman Al-Farisi (RA)", hint: "From Persia, suggested digging the trench", difficulty: .medium,
             funFact: "Salman traveled from Persia through Christianity before finding Islam, searching for the true religion."),
        Card(text: "Abu Hurairah (RA)", hint: "Narrated the most hadith", difficulty: .medium,
             funFact: "Abu Hurairah narrated over 5,300 hadiths. His name means 'Father of the Kitten' because he loved cats."),
        Card(text: "Fatimah (RA)", hint: "Daughter of the Prophet", difficulty: .medium,
             funFact: "Fatimah is known as 'Leader of the Women of Paradise' and resembled the Prophet the most."),
        Card(text: "Zaid ibn Harithah (RA)", hint: "Adopted son of the Prophet", difficulty: .medium,
             funFact: "Zaid is the only companion mentioned by name in the Quran (Surah Al-Ahzab, verse 37)."),
        Card(text: "Talha ibn Ubaydullah (RA)", hint: "One of the ten promised Paradise", difficulty: .hard,
             funFact: "Talha shielded the Prophet with his own body at Uhud, losing the use of his hand."),
        Card(text: "Zubayr ibn Al-Awwam (RA)", hint: "One of the ten promised Paradise, nephew of Khadijah", difficulty: .hard,
             funFact: "Zubayr was the first person to draw a sword in defense of Islam."),
        Card(text: "Abdur-Rahman ibn Awf (RA)", hint: "Wealthy companion, one of the ten promised Paradise", difficulty: .hard,
             funFact: "Abdur-Rahman donated 700 camels laden with goods in a single act of charity for Islam."),
        Card(text: "Sa'd ibn Abi Waqqas (RA)", hint: "First to shoot an arrow in Islam", difficulty: .hard,
             funFact: "Sa'd's prayers were known to be always answered, and the Prophet prayed for this gift for him."),
        Card(text: "Abu Ubaidah (RA)", hint: "Trustee of the Ummah", difficulty: .hard,
             funFact: "The Prophet called Abu Ubaidah the 'Trustee of this Ummah' for his unmatched honesty."),
        Card(text: "Muadh ibn Jabal (RA)", hint: "Sent to Yemen as a judge", difficulty: .hard,
             funFact: "The Prophet said Muadh was the most knowledgeable of the companions about halal and haram."),
        Card(text: "Ammar ibn Yasir (RA)", hint: "His family were the first martyrs", difficulty: .medium,
             funFact: "The Prophet told Ammar's family 'Be patient, for your destination is Paradise.'"),
        Card(text: "Sumayyah (RA)", hint: "First martyr in Islam", difficulty: .medium,
             funFact: "Sumayyah was killed for refusing to renounce Islam, becoming the very first martyr."),
        Card(text: "Mus'ab ibn Umayr (RA)", hint: "First ambassador of Islam to Madinah", difficulty: .hard,
             funFact: "Mus'ab gave up a life of luxury to spread Islam and was so poor he was buried in a short cloak."),
        Card(text: "Abu Dharr Al-Ghifari (RA)", hint: "Known for his asceticism and honesty", difficulty: .hard,
             funFact: "The Prophet said no one under the sky is more truthful than Abu Dharr."),
        Card(text: "Hassan ibn Ali (RA)", hint: "Grandson of the Prophet, known for making peace", difficulty: .medium,
             funFact: "Hassan gave up the caliphate to unite the Muslim community, fulfilling a prophecy of the Prophet."),
        Card(text: "Husayn ibn Ali (RA)", hint: "Grandson of the Prophet, martyred at Karbala", difficulty: .medium,
             funFact: "The Prophet said Hassan and Husayn are the leaders of the youth of Paradise."),
    ]

    // MARK: - Quran Cards
    static let quranCards: [Card] = [
        Card(text: "Surah Al-Fatiha", hint: "The Opening, recited in every prayer", difficulty: .easy,
             funFact: "Al-Fatiha is recited at least 17 times daily in the five obligatory prayers."),
        Card(text: "Surah Al-Baqarah", hint: "The Cow, longest surah in the Quran", difficulty: .easy,
             funFact: "Al-Baqarah has 286 verses and its recitation protects the home from Shaytan for three days."),
        Card(text: "Surah Yasin", hint: "Called the Heart of the Quran", difficulty: .easy,
             funFact: "The Prophet said everything has a heart, and the heart of the Quran is Surah Yasin."),
        Card(text: "Surah Al-Kahf", hint: "The Cave, recommended to read on Fridays", difficulty: .easy,
             funFact: "Reading Al-Kahf on Friday provides a light between two Fridays according to hadith."),
        Card(text: "Surah Al-Mulk", hint: "The Sovereignty, protects from the grave", difficulty: .medium,
             funFact: "Al-Mulk intercedes for its reader and protects from the punishment of the grave."),
        Card(text: "Surah Ar-Rahman", hint: "The Most Merciful, repeats 'Which favors will you deny?'", difficulty: .easy,
             funFact: "The phrase 'Which favors of your Lord will you deny?' is repeated 31 times in this surah."),
        Card(text: "Surah Al-Ikhlas", hint: "Sincerity, equal to one-third of the Quran", difficulty: .easy,
             funFact: "Reading Al-Ikhlas three times equals the reward of reading the entire Quran."),
        Card(text: "Surah Al-Falaq", hint: "The Daybreak, a protective surah", difficulty: .medium,
             funFact: "Al-Falaq and An-Nas together are called Al-Mu'awwidhatayn (the two protectors)."),
        Card(text: "Surah An-Nas", hint: "Mankind, the last surah", difficulty: .medium,
             funFact: "An-Nas seeks protection from whispers of evil, whether from jinn or humans."),
        Card(text: "Ayat Al-Kursi", hint: "The Throne Verse in Al-Baqarah", difficulty: .easy,
             funFact: "Ayat Al-Kursi is considered the greatest verse in the Quran according to the Prophet."),
        Card(text: "Surah Al-Isra", hint: "The Night Journey", difficulty: .medium,
             funFact: "This surah describes the miraculous night journey from Makkah to Jerusalem and beyond."),
        Card(text: "Surah Maryam", hint: "Named after the mother of Isa", difficulty: .medium,
             funFact: "Maryam is the only woman mentioned by name in the Quran and has an entire surah named after her."),
        Card(text: "Surah Yusuf", hint: "Tells the most beautiful story", difficulty: .medium,
             funFact: "Allah calls the story of Yusuf 'the best of stories' in the Quran itself."),
        Card(text: "Surah Al-Hujurat", hint: "The Rooms, teaches manners and brotherhood", difficulty: .hard,
             funFact: "This surah establishes that no race is superior to another — only piety distinguishes people."),
        Card(text: "Surah Al-Waqiah", hint: "The Event, about the Day of Judgment", difficulty: .medium,
             funFact: "The Prophet encouraged reading Al-Waqiah every night to be protected from poverty."),
        Card(text: "Surah Al-Hadid", hint: "Iron, mentions iron sent down from the sky", difficulty: .hard,
             funFact: "Modern science confirms that iron on Earth originally came from outer space via meteorites."),
        Card(text: "Surah Al-Jumu'ah", hint: "Friday, about the congregational prayer", difficulty: .hard,
             funFact: "Friday is considered the best day of the week in Islam, when Adam was created and entered Paradise."),
        Card(text: "Surah Al-Anfal", hint: "The Spoils of War, about Badr", difficulty: .hard,
             funFact: "This surah was revealed after the Battle of Badr, where 313 Muslims defeated over 1,000 opponents."),
        Card(text: "Surah At-Tawbah", hint: "Repentance, the only surah without Bismillah", difficulty: .medium,
             funFact: "At-Tawbah is the only surah that doesn't begin with Bismillah because it was revealed as a stern warning."),
        Card(text: "Surah An-Noor", hint: "The Light, contains rulings on modesty", difficulty: .hard,
             funFact: "This surah contains the famous 'Verse of Light' describing Allah's light with a beautiful parable."),
        Card(text: "Surah Al-Asr", hint: "Time, one of the shortest surahs", difficulty: .medium,
             funFact: "Imam Shafi'i said if only this surah was revealed, it would be sufficient guidance for humanity."),
        Card(text: "Surah Al-Kawthar", hint: "Abundance, the shortest surah", difficulty: .medium,
             funFact: "Al-Kawthar has only 3 verses and refers to a river in Paradise promised to the Prophet."),
        Card(text: "Juz Amma", hint: "The 30th part of the Quran, commonly memorized first", difficulty: .easy,
             funFact: "Juz Amma contains 37 surahs and is typically the first part children memorize."),
        Card(text: "Surah Al-Imran", hint: "Family of Imran, about Maryam's family", difficulty: .medium,
             funFact: "Al-Baqarah and Al-Imran are called 'the two bright ones' that will shade their reader on Judgment Day."),
        Card(text: "Surah Luqman", hint: "Named after a wise man advising his son", difficulty: .hard,
             funFact: "Luqman's advice to his son covers gratitude, prayer, patience, and humility in just a few verses."),
    ]

    // MARK: - Islamic Terms & Concepts Cards
    static let conceptsCards: [Card] = [
        Card(text: "Shahada", hint: "Declaration of faith, first pillar", difficulty: .easy,
             funFact: "The Shahada has two parts: testifying there is no god but Allah, and that Muhammad is His messenger."),
        Card(text: "Salah", hint: "The five daily prayers", difficulty: .easy,
             funFact: "Salah was prescribed during the Prophet's night journey (Mi'raj), originally 50 prayers reduced to 5."),
        Card(text: "Zakat", hint: "Obligatory charity, 2.5% of wealth", difficulty: .easy,
             funFact: "Zakat purifies wealth and is due once a year on savings held above the nisab threshold."),
        Card(text: "Sawm", hint: "Fasting during Ramadan", difficulty: .easy,
             funFact: "Fasting was prescribed in the second year of Hijrah and includes abstaining from food, drink, and more."),
        Card(text: "Hajj", hint: "Pilgrimage to Makkah", difficulty: .easy,
             funFact: "Over 2 million Muslims perform Hajj annually, making it the largest annual gathering in the world."),
        Card(text: "Tawhid", hint: "Oneness of Allah", difficulty: .medium,
             funFact: "Tawhid is the central concept of Islam, encompassing Allah's oneness in lordship, worship, and names."),
        Card(text: "Sunnah", hint: "Practices and traditions of the Prophet", difficulty: .easy,
             funFact: "The Sunnah complements the Quran and includes the Prophet's sayings, actions, and approvals."),
        Card(text: "Hadith", hint: "Recorded sayings of the Prophet", difficulty: .easy,
             funFact: "Imam Bukhari reviewed 600,000 hadiths and selected only 7,275 for his authentic collection."),
        Card(text: "Wudu", hint: "Ablution before prayer", difficulty: .easy,
             funFact: "On the Day of Judgment, Muslims will be recognized by the glow of light from their wudu."),
        Card(text: "Tayammum", hint: "Dry ablution with clean earth", difficulty: .medium,
             funFact: "Tayammum is a mercy from Allah, permitted when water is unavailable or harmful to use."),
        Card(text: "Qibla", hint: "Direction of prayer toward the Ka'bah", difficulty: .medium,
             funFact: "The Qibla was originally toward Jerusalem and was changed to Makkah in the 2nd year of Hijrah."),
        Card(text: "Adhan", hint: "The call to prayer", difficulty: .medium,
             funFact: "The adhan was established after a companion saw its exact wording in a dream."),
        Card(text: "Iqamah", hint: "Second call right before prayer starts", difficulty: .hard,
             funFact: "The iqamah is similar to the adhan but faster and with an added line about prayer starting."),
        Card(text: "Jannah", hint: "Paradise", difficulty: .easy,
             funFact: "Jannah has eight gates and multiple levels, with Firdaus being the highest level."),
        Card(text: "Jahannam", hint: "Hellfire", difficulty: .medium,
             funFact: "Jahannam has seven levels and seven gates, each assigned for different types of sinners."),
        Card(text: "Tawbah", hint: "Repentance to Allah", difficulty: .medium,
             funFact: "Allah's mercy is so vast that He is happier with a servant's repentance than a lost traveler finding their camel."),
        Card(text: "Dua", hint: "Personal supplication to Allah", difficulty: .easy,
             funFact: "The Prophet called dua 'the essence of worship' and said it can change destiny."),
        Card(text: "Dhikr", hint: "Remembrance of Allah", difficulty: .medium,
             funFact: "SubhanAllah, Alhamdulillah, and Allahu Akbar 33 times each after prayer is a beloved form of dhikr."),
        Card(text: "Ummah", hint: "The global Muslim community", difficulty: .medium,
             funFact: "The Muslim Ummah spans every continent with nearly 2 billion members worldwide."),
        Card(text: "Hijrah", hint: "Migration from Makkah to Madinah", difficulty: .medium,
             funFact: "The Islamic calendar begins from the Hijrah in 622 CE, marking the birth of the Muslim community."),
        Card(text: "Isra & Mi'raj", hint: "Night journey and ascension", difficulty: .medium,
             funFact: "During the Mi'raj, the Prophet met previous prophets in different levels of heaven."),
        Card(text: "Taqwa", hint: "God-consciousness and piety", difficulty: .medium,
             funFact: "The Prophet said taqwa is in the heart, pointing to his chest three times."),
        Card(text: "Sadaqah", hint: "Voluntary charity", difficulty: .easy,
             funFact: "Even a smile is considered sadaqah in Islam. Charity is not limited to money."),
        Card(text: "Ihsan", hint: "Excellence in worship, as if you see Allah", difficulty: .hard,
             funFact: "Ihsan is the highest level of faith: to worship Allah as though you see Him."),
        Card(text: "Barakah", hint: "Divine blessings", difficulty: .medium,
             funFact: "Barakah can be found in waking early, eating together, and in certain times like Ramadan."),
        Card(text: "Fitrah", hint: "Natural disposition toward good", difficulty: .hard,
             funFact: "Every child is born upon the fitrah — a natural inclination to recognize and worship Allah."),
        Card(text: "Shura", hint: "Mutual consultation", difficulty: .hard,
             funFact: "Shura is a Quranic principle of governance where leaders consult their community before decisions."),
        Card(text: "Khutbah", hint: "Friday sermon", difficulty: .medium,
             funFact: "The Friday khutbah replaces two rakaat of Dhuhr prayer and attendance is obligatory for men."),
        Card(text: "Nikah", hint: "Islamic marriage contract", difficulty: .medium,
             funFact: "The Prophet said nikah is half of one's faith and encouraged marriage as an act of worship."),
        Card(text: "Janazah", hint: "Funeral prayer", difficulty: .hard,
             funFact: "Janazah prayer is a communal obligation (fard kifayah) — if some perform it, others are excused."),
    ]

    // MARK: - Islamic Trivia Cards
    // Format: text = ANSWER (on forehead), hint = QUESTION (friends read aloud)
    static let triviaCards: [Card] = [
        // Easy
        Card(text: "5", hint: "How many pillars of Islam are there?", difficulty: .easy,
             funFact: "The five pillars are Shahada, Salah, Zakat, Sawm, and Hajj — the foundation of a Muslim's life."),
        Card(text: "Prophet Muhammad (SAW)", hint: "To whom was the Quran revealed?", difficulty: .easy,
             funFact: "The Quran was revealed over 23 years, beginning in the month of Ramadan in the Cave of Hira."),
        Card(text: "Makkah", hint: "In which city was Prophet Muhammad (SAW) born?", difficulty: .easy,
             funFact: "Makkah is home to the Ka'bah and is the holiest city in Islam, located in modern-day Saudi Arabia."),
        Card(text: "Ramadan", hint: "During which month do Muslims fast from dawn to sunset?", difficulty: .easy,
             funFact: "Ramadan is the 9th month of the Islamic calendar and is when the Quran was first revealed."),
        Card(text: "The Ka'bah", hint: "What is the cube-shaped structure in the center of Masjid al-Haram?", difficulty: .easy,
             funFact: "The Ka'bah was originally built by Prophet Ibrahim and his son Ismail as the first house of worship."),
        Card(text: "5 daily prayers", hint: "How many obligatory prayers must a Muslim perform each day?", difficulty: .easy,
             funFact: "The five prayers are Fajr, Dhuhr, Asr, Maghrib, and Isha — they were originally 50, reduced to 5 during Mi'raj."),
        Card(text: "Friday", hint: "On which day of the week is the congregational Jumu'ah prayer?", difficulty: .easy,
             funFact: "The Prophet said Friday is the best day the sun has risen on — Adam was created and entered Paradise on a Friday."),
        Card(text: "Arabic", hint: "In what language was the Quran revealed?", difficulty: .easy,
             funFact: "The Quran has been translated into over 100 languages but the original Arabic is used for prayer and recitation."),
        Card(text: "Angel Jibreel (AS)", hint: "Which angel delivered Allah's revelations to the prophets?", difficulty: .easy,
             funFact: "Jibreel is the chief of all angels and appeared to the Prophet in his true form only twice."),
        // Medium
        Card(text: "Madinah", hint: "To which city did the Prophet migrate during the Hijra?", difficulty: .medium,
             funFact: "Madinah was originally called Yathrib and was renamed Madinah al-Munawwarah — the Radiant City."),
        Card(text: "114", hint: "How many surahs are in the Quran?", difficulty: .medium,
             funFact: "The longest surah is Al-Baqarah with 286 verses and the shortest is Al-Kawthar with just 3 verses."),
        Card(text: "23 years", hint: "Over how many years was the Quran revealed to the Prophet?", difficulty: .medium,
             funFact: "The gradual revelation helped the early Muslims understand and implement the teachings step by step."),
        Card(text: "Cave of Hira", hint: "In which cave did Prophet Muhammad receive the first revelation?", difficulty: .medium,
             funFact: "The Cave of Hira is on Jabal al-Noor (Mountain of Light) near Makkah and is about 3.5 meters long."),
        Card(text: "Khadijah (RA)", hint: "Who was the first person to accept Islam?", difficulty: .medium,
             funFact: "Khadijah was 15 years older than the Prophet and was one of the wealthiest traders in Makkah."),
        Card(text: "Bilal (RA)", hint: "Who was the first muezzin — the first person to call the adhan?", difficulty: .medium,
             funFact: "Bilal was an Abyssinian slave who endured severe torture for his faith before Abu Bakr freed him."),
        Card(text: "Al-Fatiha", hint: "What is the name of the opening surah of the Quran?", difficulty: .medium,
             funFact: "Al-Fatiha means 'The Opening' and it must be recited in every unit of prayer, at least 17 times a day."),
        Card(text: "Jerusalem", hint: "Which city did the Prophet visit during the night journey of Isra?", difficulty: .medium,
             funFact: "The Prophet led all previous prophets in prayer at Masjid al-Aqsa before ascending through the heavens."),
        Card(text: "10 companions", hint: "How many companions were specifically promised Paradise by the Prophet?", difficulty: .medium,
             funFact: "Known as Al-Ashara al-Mubashshara, they include Abu Bakr, Umar, Uthman, Ali, and six others."),
        // Hard
        Card(text: "Sumayyah (RA)", hint: "Who was the first martyr in Islamic history?", difficulty: .hard,
             funFact: "Sumayyah bint Khayyat was killed by Abu Jahl for refusing to renounce Islam."),
        Card(text: "622 CE", hint: "In what year did the Hijra — the migration to Madinah — take place?", difficulty: .hard,
             funFact: "The year 622 CE marks the start of the Islamic calendar, chosen by Caliph Umar as the defining moment."),
        Card(text: "Abyssinia (Ethiopia)", hint: "To which land did the first group of Muslim refugees migrate?", difficulty: .hard,
             funFact: "The Negus (King) of Abyssinia wept when he heard the Quran recited and gave the Muslims protection."),
        Card(text: "40 years old", hint: "At what age did Prophet Muhammad receive the first revelation?", difficulty: .hard,
             funFact: "The first word revealed was 'Iqra' (Read), beginning Surah Al-Alaq in the Cave of Hira."),
        Card(text: "Treaty of Hudaybiyyah", hint: "What peace treaty in 6 AH was called a 'clear victory' by the Quran?", difficulty: .hard,
             funFact: "Though it seemed unfavorable, this treaty led to a period of peace that allowed Islam to spread rapidly."),
        Card(text: "Approximately 6,236", hint: "How many verses (ayat) are in the Quran?", difficulty: .hard,
             funFact: "Scholars have slightly different counts depending on how verse divisions are marked, but 6,236 is most common."),
        Card(text: "Battle of Badr", hint: "What was the first major battle in Islamic history, fought in 2 AH?", difficulty: .hard,
             funFact: "313 poorly-equipped Muslims defeated over 1,000 Quraysh soldiers with divine assistance."),
    ]
}

// MARK: - Timer Options

enum TimerOption: Int, CaseIterable, Identifiable {
    case sixty = 60
    case ninety = 90
    case oneTwenty = 120

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .sixty: return "60s"
        case .ninety: return "90s"
        case .oneTwenty: return "120s"
        }
    }
}
