import SwiftUI

struct ResultView: View {
    let result: Bool
    let frenchWord: String
    let nextWord: () -> Void
    
    var body: some View {
        VStack {
            Text(result ? "Correct!" : "Incorrect!")
                .font(.title)
                .foregroundColor(result ? .green : .red)
            
            Text(frenchWord)
                .font(.title2)
            
            Button("Next") {
                nextWord()
            }
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
        }
        .padding()
        .background(result ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
        .cornerRadius(20)
    }
}
