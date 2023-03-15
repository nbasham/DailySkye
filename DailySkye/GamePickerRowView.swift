import SwiftUI

struct GamePickerRowView: View {
    let game: GameDescriptor
    @ObservedObject var viewModel: HomePage.ViewModel
    var height: CGFloat = 44
    @State private var isRotating = 0.0

    var body: some View {
        GridRow {
            gameName
            gameBall
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.gameSelected(game)
        }
    }

    var gameName: some View {
        Text(game.displayName)
            .fontWeight(.medium)
            .gridColumnAlignment(.trailing)
            .offset(x: viewModel.animateGame == game ? 30 : 0)
    }

    var gameBall: some View {
        Circle()
            .fill(game.color)
            .frame(height: max(0, height))
            .overlay(
                Text("play")
                    .fontWeight(.semibold)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .offset(y: -1)
            )
            .rotationEffect(.degrees(viewModel.animateBall == game && viewModel.isRotating ? 5*360 : 0))
            .offset(x: viewModel.animateBall == game ? UIScreen.main.bounds.width : 0)
    }
}

struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 4) {
            GamePickerRowView(game: .memory, viewModel: HomePage.ViewModel(), height: 44)
            GamePickerRowView(game: .word_search, viewModel: HomePage.ViewModel(), height: 44)
        }
        .padding(.leading, 100)
            .previewInterfaceOrientation(.landscapeRight)
            .previewLayout(.sizeThatFits)
    }
}
