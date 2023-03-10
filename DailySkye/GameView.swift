import SwiftUI

struct GameView: View {
    let game: GameDescriptor
    var size: CGSize

    var body: some View {
            GeometryReader { proxy in
                Text("\(proxy.size.debugDescription) \(size.debugDescription)")
                ZStack {
                    Color.clear
                    Text("Solve")
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
