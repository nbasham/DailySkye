import SwiftUI

struct GamePickerRowView: View {
    let game: GameDescriptor
    @ObservedObject var viewModel: HomePageViewModel
    var height: CGFloat = 44
    @State private var isRotating = 0.0

    var body: some View {
        GridRow {
            gameName
            gameBall
            Spacer()
        }
        .padding(.vertical, viewModel.verticalSpacing/2)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.gameSelected(game)
        }
    }

    var gameName: some View {
        Text(game.displayName)
            .fontWeight(.medium)
            .fixedSize() // prevents truncation
            .gridColumnAlignment(.trailing)
            .offset(x: viewModel.animateGame == game ? 30 : 0)
    }

    var gameBall: some View {
        Circle()
            .fill(
//                AngularGradient(gradient: Gradient(colors: [game.color, game.color.opacity(0.8), game.color]), center: .center)
                game.color
            )
            .aspectRatio(1, contentMode: .fit)
//            .frame(height: max(0, height))
            .overlay(
                Text("play")
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .fontWeight(.semibold)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .offset(y: -1)
                    .padding(3) // pushes 'play' from circle edge
            )
            .rotationEffect(.degrees(viewModel.animateBall == game && viewModel.isRotating ? 5*360 : 0))
            .offset(x: viewModel.animateBall == game ? UIScreen.main.bounds.width : 0)
    }
}

struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 4) {
            GamePickerRowView(game: .memory, viewModel: HomePageViewModel(), height: 44)
            GamePickerRowView(game: .word_search, viewModel: HomePageViewModel(), height: 44)
        }
        .padding(.leading, 100)
            .previewInterfaceOrientation(.landscapeRight)
            .previewLayout(.sizeThatFits)
    }
}
