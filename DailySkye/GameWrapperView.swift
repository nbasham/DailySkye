import SwiftUI

struct GameWrapperView: View {
    let game: GameDescriptor

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            GeometryReader { proxy in
                GameView(game: game, size: proxy.size)
            }
        }
        .navigationBarTitle(game.displayName, displayMode: .inline)
    }
}

struct GameWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameWrapperView(game: GameDescriptor.cryptogram)
        }
        .previewInterfaceOrientation(.landscapeRight)
    }
}
