import SwiftUI

struct ReplayMissedWordsView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let group: WordGroup  // Add this line
    @State private var currentWordIndex = 0
    @State private var showingAnswer = false
    @State private var isCorrect = false
    @Environment(\.presentationMode) var presentationMode

    var missedWords: [Word] {
        gameViewModel.getMissedWords(for: group)  // Update this line
    }

    var body: some View {
        ZStack {
            if showingAnswer {
                (isCorrect ? Color.green : Color.red).edgesIgnoringSafeArea(.all)
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
            }

            VStack {
                if currentWordIndex < missedWords.count {
                    if !showingAnswer {
                        Text(missedWords[currentWordIndex].englishWord)
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
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    } else {
                        Text(isCorrect ? "Correct!" : "Incorrect!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text(missedWords[currentWordIndex].englishWord)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text(missedWords[currentWordIndex].frenchWord)
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                        
                        Button("Next Word") {
                            nextWord()
                        }
                        .font(.title3)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(isCorrect ? .green : .red)
                        .cornerRadius(10)
                        .padding(.top, 20)
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

                Spacer()

                Button("End Game") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Replay Missed Words")
    }
    
    func checkAnswer(_ gender: Gender) {
        isCorrect = gender == missedWords[currentWordIndex].gender
        showingAnswer = true
    }
    
    func nextWord() {
        currentWordIndex += 1
        showingAnswer = false
    }
}
