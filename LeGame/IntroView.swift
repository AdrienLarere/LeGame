import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool
    @StateObject private var gameViewModel: GameViewModel
    
    @State private var showExplosion = false
    @State private var showText = false
    @State private var showButton = false
    @State private var imageScale: CGFloat = 2  // Initial scale for 50% bigger
    
    // Add this initializer
    public init(showIntro: Binding<Bool>, gameViewModel: GameViewModel) {
        self._showIntro = showIntro
        self._gameViewModel = StateObject(wrappedValue: gameViewModel)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if showExplosion {
                ExplosionView()
            }
            
            VStack {
                Text("Are you cool enough for Le French?!?!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.bottom, 150)  // Adjusted padding to move text higher
                
                Image("ready_image")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(imageScale)
                    .frame(width: 300, height: 150)  // Adjusted frame size
                    .padding(.top, -80)  // Nudged the image further up
                    .opacity(showButton ? 1 : 0)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            imageScale = 2.5  // Scale for pop effect (80% bigger than 1.75)
                        }
                    }
                    .onTapGesture {
                        gameViewModel.startGame()
                        withAnimation {
                            showIntro = false
                        }
                    }
                    .transition(.scale)
            }
        }
        .onAppear {
            animate()
        }
    }
    
    private func animate() {
        withAnimation(.easeIn(duration: 0.5)) {
            showExplosion = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.spring()) {
                showText = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring()) {
                showButton = true
            }
        }
    }
}

struct ExplosionView: View {
    @State private var scale: CGFloat = 0.1
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .scaleEffect(scale)
                .opacity(2 - scale)
            
            Circle()
                .fill(Color.pink)
                .scaleEffect(scale * 0.8)
                .opacity(2 - scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                scale = 2
            }
        }
    }
}

struct BurstShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = 8
        let angle = 2 * .pi / Double(points)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<points * 2 {
            let currentAngle = angle * Double(i)
            let distance = i % 2 == 0 ? radius : radius * 0.7
            let x = center.x + CGFloat(cos(currentAngle)) * distance
            let y = center.y + CGFloat(sin(currentAngle)) * distance
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}
