import SwiftUI

struct SprinklesView: View {
    @State private var sprinkles: [(CGPoint, Color, Double)] = [] // (position, color, offset)
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<sprinkles.count, id: \.self) { index in
                Circle()
                    .fill(sprinkles[index].1)
                    .frame(width: 5, height: 5)
                    .position(sprinkles[index].0)
            }
        }
        .onAppear {
            createSprinkles()
        }
        .onReceive(timer) { _ in
            moveSprinkles()
        }
    }
    
    func createSprinkles() {
        for _ in 0..<150 { // Increased count to add more variety
            let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
            let color = [Color.white, Color.yellow, Color(red: 1.0, green: 0.7, blue: 0.7)].randomElement()! // Light pink added
            let offset = Double.random(in: 0...1)
            sprinkles.append((CGPoint(x: x, y: y), color, offset))
        }
    }
    
    func moveSprinkles() {
        for i in 0..<sprinkles.count {
            var newPosition = sprinkles[i].0
            newPosition.y -= 2.4
            if newPosition.y < -10 {
                newPosition.y = UIScreen.main.bounds.height + 10
            }
            sprinkles[i].0 = newPosition
        }
    }
}

struct FlamesView: View {
    @State private var flames: [(CGPoint, Color, Double)] = [] // (position, color, offset)
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<flames.count, id: \.self) { index in
                Image(systemName: "flame.fill")
                    .foregroundColor(flames[index].1)
                    .font(.system(size: 24))
                    .position(flames[index].0)
            }
        }
        .onAppear {
            createFlames()
        }
        .onReceive(timer) { _ in
            moveFlames()
        }
    }
    
    func createFlames() {
        for _ in 0..<60 {
            let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
            let color = [Color.purple, Color.black, Color.white].randomElement()!
            let offset = Double.random(in: 0...1)
            flames.append((CGPoint(x: x, y: y), color, offset))
        }
    }
    
    func moveFlames() {
        for i in 0..<flames.count {
            var newPosition = flames[i].0
            newPosition.y += 2.4
            if newPosition.y > UIScreen.main.bounds.height + 10 {
                newPosition.y = -10
            }
            flames[i].0 = newPosition
        }
    }
}
