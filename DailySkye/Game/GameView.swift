import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GamePage.ViewModel
    var size: CGSize

    var body: some View {
        ZStack {
            Color.clear
            VStack {
                Text("Solve")
                Text("\(size.debugDescription)")
            }
        }
        .border(viewModel.game.color)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GamePage.ViewModel(game: GameDescriptor.cryptogram), size: .zero)
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
