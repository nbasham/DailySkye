import SwiftUI

struct HomeGamePickerRowView: View {
    let game: GameDescriptor
    @ObservedObject var viewModel: HomePageViewModel
    @State private var isRotating = 0.0

    var body: some View {
        GridRow {
            gameName
            gameBall
            Spacer()
        }
        .padding(.vertical, viewModel.pickerBallVMargin/2)
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
            .offset(x: viewModel.animateGame == game ? viewModel.nameToBallSpace*1.5 : 0)
    }

    var gameBall: some View {
        Circle()
            .fill(
                game.color
            )
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(-45))
            .overlay(
                gameBallFill
            )
            .rotationEffect(.degrees(viewModel.animateBall == game && viewModel.isRotating ? 5*360 : 0))
            .offset(x: viewModel.animateBall == game ? UIScreen.main.bounds.width : 0)
    }

    @ViewBuilder
    var gameBallFill: some View {
        if History.isCompleted(game: game) {
            Image(systemName: "checkmark")
                .bold()
                .foregroundColor(.white)
        } else {
            Text("play")
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .fontWeight(.semibold)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .offset(y: -1)
                .padding(3) // pushes 'play' from circle edge
        }
    }

    private var ballGradient: Gradient {
        let color = game.color
        let lightColor = Color(uiColor: UIColor(game.color).lighter(componentDelta: 0.1))
        let darkColor = Color(uiColor: UIColor(game.color).darker(componentDelta: 0.15))
        return Gradient(colors: [lightColor, color, darkColor])
    }
}

struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 4) {
            HomeGamePickerRowView(game: .memory, viewModel: HomePageViewModel())
            HomeGamePickerRowView(game: .word_search, viewModel: HomePageViewModel())
        }
        .padding(.leading, 100)
            .previewInterfaceOrientation(.landscapeRight)
            .previewLayout(.sizeThatFits)
    }
}
