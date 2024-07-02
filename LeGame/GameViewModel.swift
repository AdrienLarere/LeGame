import Foundation
import FirebaseFirestore

class GameViewModel: ObservableObject {
    @Published var currentWord: Word?
    @Published var currentScore: Int = 0
    @Published var bestScore: Int = 0
    @Published var showResult: Bool = false
    @Published var lastResult: Bool = false
    @Published var selectedWordGroup: WordGroup = .basic
    @Published var isGameInProgress: Bool = false
    
    private var words: [Word] = []
    private let db = Firestore.firestore()
    private var missedWords: Set<Word> = []
    
    func startGame() {
        loadWords()
        currentScore = 0
        isGameInProgress = true
        missedWords.removeAll()
    }
    
    func endGame() {
        isGameInProgress = false
        currentWord = nil
        showResult = false
        saveMissedWords()
        saveBestScore()
    }
    
    func replayMissedWords(for group: WordGroup) {
        words = getMissedWords(for: group)
        currentScore = 0
        isGameInProgress = true
        nextWord()
    }

    func endReplay() {
        isGameInProgress = false
        currentWord = nil
        showResult = false
    }
    
    func loadWords() {
        switch selectedWordGroup {
        case .basic:
            words = loadBasicWords()
        case .common:
            words = loadCommonWords()
        case .family:
            words = loadFamilyWords()
        case .anatomy:
            words = loadAnatomyWords()
        case .all:
            words = loadBasicWords() + loadCommonWords() + loadFamilyWords() + loadAnatomyWords()
        }
        nextWord()
    }
    
    func getAllMissedWords() -> [Word] {
        return Array(missedWords)
    }
    
    private func loadBasicWords() -> [Word] {
        return [
            Word(englishWord: "Time", frenchWord: "Le temps", gender: .masculine),
            Word(englishWord: "Year", frenchWord: "L'année", gender: .feminine),
            Word(englishWord: "Day", frenchWord: "Le jour", gender: .masculine),
            Word(englishWord: "Thing", frenchWord: "La chose", gender: .feminine),
            Word(englishWord: "Man", frenchWord: "L'homme", gender: .masculine),
            Word(englishWord: "World", frenchWord: "Le monde", gender: .masculine),
            Word(englishWord: "Life", frenchWord: "La vie", gender: .feminine),
            Word(englishWord: "Hand", frenchWord: "La main", gender: .feminine),
            Word(englishWord: "Part", frenchWord: "La partie", gender: .feminine),
            Word(englishWord: "Child", frenchWord: "L'enfant", gender: .masculine),
            Word(englishWord: "Eye", frenchWord: "L'œil", gender: .masculine),
            Word(englishWord: "Woman", frenchWord: "La femme", gender: .feminine),
            Word(englishWord: "Place", frenchWord: "L'endroit", gender: .masculine),
            Word(englishWord: "Work", frenchWord: "Le travail", gender: .masculine),
            Word(englishWord: "Week", frenchWord: "La semaine", gender: .feminine),
            Word(englishWord: "Case", frenchWord: "Le cas", gender: .masculine),
            Word(englishWord: "Point", frenchWord: "Le point", gender: .masculine),
            Word(englishWord: "Government", frenchWord: "Le gouvernement", gender: .masculine),
            Word(englishWord: "Company", frenchWord: "L'entreprise", gender: .feminine),
            Word(englishWord: "Number", frenchWord: "Le nombre", gender: .masculine),
            Word(englishWord: "Group", frenchWord: "Le groupe", gender: .masculine),
            Word(englishWord: "Problem", frenchWord: "Le problème", gender: .masculine),
            Word(englishWord: "Fact", frenchWord: "Le fait", gender: .masculine),
            Word(englishWord: "Money", frenchWord: "L'argent", gender: .masculine),
            Word(englishWord: "Month", frenchWord: "Le mois", gender: .masculine),
            Word(englishWord: "Right", frenchWord: "Le droit", gender: .masculine),
            Word(englishWord: "Study", frenchWord: "L'étude", gender: .feminine),
            Word(englishWord: "Book", frenchWord: "Le livre", gender: .masculine),
            Word(englishWord: "Job", frenchWord: "L'emploi", gender: .masculine),
            Word(englishWord: "Night", frenchWord: "La nuit", gender: .feminine),
            Word(englishWord: "Word", frenchWord: "Le mot", gender: .masculine),
            Word(englishWord: "Example", frenchWord: "L'exemple", gender: .masculine),
            Word(englishWord: "Family", frenchWord: "La famille", gender: .feminine),
            Word(englishWord: "Country", frenchWord: "Le pays", gender: .masculine),
            Word(englishWord: "Question", frenchWord: "La question", gender: .feminine),
            Word(englishWord: "School", frenchWord: "L'école", gender: .feminine),
            Word(englishWord: "State", frenchWord: "L'état", gender: .masculine),
            Word(englishWord: "Student", frenchWord: "L'étudiant", gender: .masculine),
            Word(englishWord: "Program", frenchWord: "Le programme", gender: .masculine),
            Word(englishWord: "Minute", frenchWord: "La minute", gender: .feminine),
            Word(englishWord: "Good", frenchWord: "Le bien", gender: .masculine),
            Word(englishWord: "Hour", frenchWord: "L'heure", gender: .feminine),
            Word(englishWord: "Guy", frenchWord: "Le type", gender: .masculine),
            Word(englishWord: "Moment", frenchWord: "Le moment", gender: .masculine),
            Word(englishWord: "Teacher", frenchWord: "Le professeur", gender: .masculine),
            Word(englishWord: "Issue", frenchWord: "Le problème", gender: .masculine),
            Word(englishWord: "Kind", frenchWord: "Le genre", gender: .masculine),
            Word(englishWord: "Head", frenchWord: "La tête", gender: .feminine),
            Word(englishWord: "House", frenchWord: "La maison", gender: .feminine),
            Word(englishWord: "Service", frenchWord: "Le service", gender: .masculine)
        ]
    }
    
    private func loadCommonWords() -> [Word] {
        return [
            Word(englishWord: "House", frenchWord: "La maison", gender: .feminine),
            Word(englishWord: "Car", frenchWord: "La voiture", gender: .feminine),
            Word(englishWord: "Book", frenchWord: "Le livre", gender: .masculine)
            // Add more common words here
        ]
    }
    
    private func loadFamilyWords() -> [Word] {
        return [
            Word(englishWord: "Mother", frenchWord: "La mère", gender: .feminine),
            Word(englishWord: "Father", frenchWord: "Le père", gender: .masculine),
            Word(englishWord: "Sister", frenchWord: "La sœur", gender: .feminine)
            // Add more family words here
        ]
    }
    
    private func loadAnatomyWords() -> [Word] {
        return [
            Word(englishWord: "Head", frenchWord: "La tête", gender: .feminine),
            Word(englishWord: "Arm", frenchWord: "Le bras", gender: .masculine),
            Word(englishWord: "Leg", frenchWord: "La jambe", gender: .feminine)
            // Add more anatomy words here
        ]
    }
    
    func nextWord() {
        currentWord = words.randomElement()
        showResult = false
    }
    
    func checkAnswer(gender: Gender) {
        guard let currentWord = currentWord else { return }
        
        lastResult = currentWord.gender == gender
        if lastResult {
            currentScore += 1
            if currentScore > bestScore {
                bestScore = currentScore
                saveBestScore()
            }
        } else {
            missedWords.insert(currentWord)
        }
        
        showResult = true
    }
    
    func deleteMissedWords(for group: WordGroup? = nil) {
        if let group = group {
            missedWords = missedWords.filter { word in
                !getMissedWords(for: group).contains(word)
            }
        } else {
            missedWords.removeAll()
        }
        saveMissedWords()
    }
    
    private func saveBestScore() {
        UserDefaults.standard.set(bestScore, forKey: "bestScore")
    }

    private func loadBestScore() {
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
    }

    private func saveMissedWords() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Array(missedWords)) {
            UserDefaults.standard.set(encoded, forKey: "missedWords")
        }
    }

    private func loadMissedWords() {
        if let savedWords = UserDefaults.standard.data(forKey: "missedWords") {
            let decoder = JSONDecoder()
            if let loadedWords = try? decoder.decode([Word].self, from: savedWords) {
                missedWords = Set(loadedWords)
            }
        }
    }
    
    func getMissedWords(for group: WordGroup) -> [Word] {
        // Filter missed words based on the selected group
        return Array(missedWords).filter { word in
            switch group {
            case .basic:
                return loadBasicWords().contains(word)
            case .common:
                return loadCommonWords().contains(word)
            case .family:
                return loadFamilyWords().contains(word)
            case .anatomy:
                return loadAnatomyWords().contains(word)
            case .all:
                return true
            }
        }
    }
}

struct Word: Identifiable, Hashable, Codable {
    let id: UUID
    let englishWord: String
    let frenchWord: String
    let gender: Gender
    
    init(englishWord: String, frenchWord: String, gender: Gender) {
        self.id = UUID()
        self.englishWord = englishWord
        self.frenchWord = frenchWord
        self.gender = gender
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(englishWord)
        hasher.combine(frenchWord)
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.englishWord == rhs.englishWord && lhs.frenchWord == rhs.frenchWord
    }
}

enum Gender: String, Codable {
    case masculine
    case feminine
}

enum WordGroup: String, CaseIterable {
    case basic = "Basic Words"
    case common = "Common Words"
    case family = "Family Words"
    case anatomy = "Anatomy Words"
    case all = "All Words"
}
