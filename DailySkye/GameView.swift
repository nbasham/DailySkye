import SwiftUI

struct GameView: View {
    let game: GameDescriptor
    var size: CGSize

    var body: some View {
        ZStack {
            game.color
            Text(size.debugDescription)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: GameDescriptor.cryptogram, size: .zero)
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
