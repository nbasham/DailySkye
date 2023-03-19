import SwiftUI

struct GameSolvedView: View {
    @ObservedObject var viewModel: GamePageViewModel

    var body: some View {
        ZStack {
            viewModel.game.color
        }
        .ignoresSafeArea()
    }
}

struct GameSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        GameSolvedView(viewModel: GamePageViewModel(game: .cryptogram))
    }
}
