import SwiftUI

struct GameView: View {
    let game: GameDescriptor
    var size: CGSize
    @State private var isSolved = false

    var body: some View {
        ZStack {
            Color.clear
            VStack(spacing: 0) {
                GeometryReader { proxy in
                    VStack(spacing: 0) {
                        Text(proxy.size.debugDescription)
                        Spacer()
                        Button("Solve") {
                            withAnimation {
                                isSolved.toggle()
                            }
                        }
                        .tint(game.color)
                    }
                }
                if isSolved {
                    GameSolvedView(game: game)
                        .frame(height: 88)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .border(game.color)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: GameDescriptor.cryptogram, size: .zero)
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
