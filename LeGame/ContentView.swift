import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    @State private var showingAnswer = false
    @State private var showingSettings = false
    @State private var boyOffset: Double = 0
    @State private var girlOffset: Double = 0
    @State private var showIntro = true
    
    var body: some View {
        ZStack {
            if showIntro {
                IntroView(showIntro: $showIntro, gameViewModel: gameViewModel)
            } else {
                NavigationView {
                    VStack {
                        if !gameViewModel.isGameInProgress {
                            startGameView
                        } else {
                            gameView
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            if !gameViewModel.isGameInProgress {
                                VStack {
                                    Text("Le Game")
                                        .font(.headline)
                                    Text("La Best App to practice Le French")
                                        .font(.caption)
                                        .italic()
                                }
                            }
                        }
                        ToolbarItem(placement: .bottomBar) {
                            if !gameViewModel.isGameInProgress {
                                Button(action: {
                                    showingSettings = true
                                }) {
                                    Image(systemName: "gear")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showingAnswer) {
                    AnswerView(
                        isCorrect: gameViewModel.lastResult,
                        englishWord: gameViewModel.currentWord?.englishWord ?? "",
                        frenchWord: gameViewModel.currentWord?.frenchWord ?? "",
                        dismissAction: {
                            showingAnswer = false
                            gameViewModel.nextWord()
                        }
                    )
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView(gameViewModel: gameViewModel)
                }
            }
        }
    }
    
    private var startGameView: some View {
        VStack {
            Text("Welcome to Le Game!")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Picker("Game Mode", selection: $gameViewModel.gameMode) {
                Text("Basic Words").tag(GameMode.basic)
                Text("Everyday Words").tag(GameMode.everyday)
                Text("Advanced Words").tag(GameMode.advanced)
            }
            .pickerStyle(DefaultPickerStyle())
            .padding()
            
            Button("Start Game") {
                gameViewModel.startGame()
            }
            .font(.title2)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(10)
        }
    }
    
    private var gameView: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 60)
                
                HStack {
                    Text("Score: \(gameViewModel.currentScore)")
                        .padding()
                    Spacer()
                    Text("Best: \(gameViewModel.bestScore)")
                        .padding()
                }
                
                Spacer()
                
                if let currentWord = gameViewModel.currentWord {
                    Text(currentWord.englishWord)
                        .font(.largeTitle)
                        .padding()
                    
                    HStack(spacing: 50) {
                        VStack {
                            Image("boy_image")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .scaleEffect(2.05)
                                .rotation3DEffect(.degrees(boyOffset), axis: (x: 0, y: 1, z: 0))
                                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: boyOffset)
                                .onTapGesture {
                                    checkAnswer(.masculine)
                                }
                            
                            Text("Masculine")
                                .foregroundColor(.blue)
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        
                        VStack {
                            Image("girl_image")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .scaleEffect(1.35)
                                .rotation3DEffect(.degrees(girlOffset), axis: (x: 0, y: 1, z: 0))
                                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: girlOffset)
                                .onTapGesture {
                                    checkAnswer(.feminine)
                                }
                            
                            Text("Feminine")
                                .foregroundColor(.pink)
                                .font(.headline)
                                .padding(.top, 10)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Button("End Game") {
                    gameViewModel.endGame()
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .onAppear {
            startOscillationAnimation()
        }
    }
    
    private func checkAnswer(_ gender: Gender) {
        gameViewModel.checkAnswer(gender: gender)
        showingAnswer = true
    }
    
    private func startOscillationAnimation() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            boyOffset = 15
            girlOffset = -15
        }
    }
}

struct AnswerView: View {
    let isCorrect: Bool
    let englishWord: String
    let frenchWord: String
    let dismissAction: () -> Void
    @State private var showAnimation = false
    
    var body: some View {
        ZStack {
            isCorrect ? Color.green : Color.red
            
            if showAnimation {
                if isCorrect {
                    SprinklesView()
                } else {
                    FlamesView()
                }
            }
            
            VStack {
                Text(isCorrect ? "Correct!" : "Incorrect!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Text(englishWord)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Text(frenchWord)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                
                Button("Next Word") {
                    dismissAction()
                }
                .font(.title3)
                .padding()
                .background(Color.white)
                .foregroundColor(isCorrect ? .green : .red)
                .cornerRadius(10)
                .padding(.top, 20)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                showAnimation = true
            }
        }
    }
}
