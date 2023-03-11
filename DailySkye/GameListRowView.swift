import SwiftUI

struct GameListRowView: View {
    @EnvironmentObject var coordinator: Coordinator
    let game: GameDescriptor
    var height: CGFloat = 44

    var body: some View {
        GridRow {
            Text(game.displayName)
                .fontWeight(.medium)
                .gridColumnAlignment(.trailing)
                .offset(x: coordinator.animateGame == game ? 30 : 0)
            Circle()
                .fill(game.color)
                .frame(height: max(0, height))
                .offset(x: coordinator.animateBall == game ? UIScreen.main.bounds.width : 0)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            coordinator.gameSelected(game)
        }
    }
}

struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 4) {
            GameListRowView(game: .memory, height: 44)
                .environmentObject(Coordinator())
        }
        .padding(.leading, 100)
            .previewInterfaceOrientation(.landscapeRight)
            .previewLayout(.sizeThatFits)
    }
}
