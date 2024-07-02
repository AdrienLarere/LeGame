import SwiftUI

struct SettingsView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Review Missed Words")) {
                    NavigationLink("Basic Words", destination: ReviewWordsView(group: .basic, gameViewModel: gameViewModel))
                    NavigationLink("Common Words", destination: ReviewWordsView(group: .common, gameViewModel: gameViewModel))
                    NavigationLink("Family Words", destination: ReviewWordsView(group: .family, gameViewModel: gameViewModel))
                    NavigationLink("Anatomy Words", destination: ReviewWordsView(group: .anatomy, gameViewModel: gameViewModel))
                    NavigationLink("All Words", destination: ReviewWordsView(group: .all, gameViewModel: gameViewModel))
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ReviewWordsView: View {
    let group: WordGroup
    @ObservedObject var gameViewModel: GameViewModel
    @State private var showingReplayGame = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Missed Words")
                        .font(.headline)
                        .bold()
                    Text(group.rawValue)
                        .font(.subheadline)
                }
                Spacer()
                Button(action: {
                    showingReplayGame = true
                }) {
                    Text("Replay Missed Words")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            List(gameViewModel.getMissedWords(for: group)) { word in
                VStack(alignment: .leading) {
                    Text(word.englishWord)
                        .font(.headline)
                    Text(word.frenchWord)
                        .font(.subheadline)
                    Text(word.gender.rawValue)
                        .font(.caption)
                }
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Text("Delete this list")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Review")
        .fullScreenCover(isPresented: $showingReplayGame) {
            ReplayMissedWordsView(gameViewModel: gameViewModel, group: group)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Missed Words"),
                message: Text("Are you sure you want to delete all missed words for this group?"),
                primaryButton: .destructive(Text("Delete")) {
                    gameViewModel.deleteMissedWords(for: group)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let group: WordGroup
    let words: [Word]
    @State private var currentWordIndex = 0
    @State private var showingAnswer = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if currentWordIndex < words.count {
                Text(words[currentWordIndex].englishWord)
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Button("Masculine") {
                        checkAnswer(.masculine)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Feminine") {
                        checkAnswer(.feminine)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                if showingAnswer {
                    Text(words[currentWordIndex].frenchWord)
                        .font(.title)
                        .padding()
                    
                    Button("Next Word") {
                        nextWord()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                Text("You've completed all missed words!")
                    .font(.title)
                    .padding()
                
                Button("Return to Review") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .navigationTitle("Replay Missed Words")
    }
    
    func checkAnswer(_ gender: Gender) {
        showingAnswer = true
    }
    
    func nextWord() {
        currentWordIndex += 1
        showingAnswer = false
    }
}
