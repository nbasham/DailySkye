import SwiftUI

struct GameListRowView: View {
    @EnvironmentObject var coordinator: Coordinator
    let game: GameDescriptor

    var body: some View {
        Color.clear
            .overlay(alignment: .trailing) {
                Text(game.displayName)
                    .fontWeight(.semibold)
                    .font(.system(size: 19))
                    .offset(x: -UIScreen.main.bounds.width * 0.65)
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
            .previewInterfaceOrientation(.landscapeRight)
    }
}
