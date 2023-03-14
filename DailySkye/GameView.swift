import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameHostView.ViewModel
    var size: CGSize

    var body: some View {
            GeometryReader { proxy in
                Text("\(proxy.size.debugDescription) \(size.debugDescription)")
                ZStack {
                    Color.clear
                    Text("Solve")
                }
            }
            .border(viewModel.game.color)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameHostView.ViewModel(game: GameDescriptor.cryptogram), size: .zero)
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
