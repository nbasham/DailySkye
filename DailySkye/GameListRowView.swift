import SwiftUI

struct GameListRowView: View {
    @EnvironmentObject var coordinator: Coordinator
    let game: GameDescriptor

    var body: some View {
        Color.clear
            .overlay(alignment: .leading) {
                Text(game.displayName)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.gameSelected(game)
            }
    }
}

struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
        GameListRowView(game: .memory)
            .environmentObject(Coordinator())
    }
}
