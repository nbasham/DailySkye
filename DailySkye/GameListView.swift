import SwiftUI

struct GameListView: View {
    @StateObject var coordinator: Coordinator = Coordinator()
    @State var viewModel = GameListView.ViewModel()
    @State var showHelp: Bool = false

    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            VStack(spacing: 0) {
                ZStack {
                    Color("background")
                        .ignoresSafeArea()
                    gridView()
                        .zIndex(2)
                }
                Color("top").opacity(0.75)
                    .ignoresSafeArea()
                    .frame(height: 88/*viewModel.bottomHeight*/)
            }
            .navigationBarTitle("") // hides Back on game screen
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: GameDescriptor.self) { game in
                coordinator.startGame(game)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("top"), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ZStack(alignment: .trailing) {
                        Color.clear
                            .frame(width: 200)
                        logoView()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    menuView()
                }
            }
            .sheet(isPresented: $showHelp, content: { HelpView() })
        }
    }

    private func logoView() -> some View {
        HStack(spacing: 2) {
            Text("Daily")
                .fontWeight(.light)
            Text("Puzzles")
                .fontWeight(.heavy)
        }
        .font(.system(size: 19))
    }

    private func gridView() -> some View {
        GeometryReader { proxy in
            Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 4) {
                ForEach(viewModel.games, id: \.id) { game in
                    GameListRowView(game: game, height: floor(proxy.size.height / Double(viewModel.games.count)) - 4)
                }
                .environmentObject(coordinator)
            }
        }
        .padding(.top, 4)
        .padding(.leading, 90)
    }

    private func menuView() -> some View {
        Menu {
            Button("Help", action: { showHelp = true })
            Menu("Play sounds") {
                Picker(selection: $coordinator.isSoundOn, label: Text("")) {
                    Text("No").tag(0)
                    Text("Yes").tag(1)
                }
            }
            Menu("Level") {
                Picker(selection: $coordinator.level, label: Text("Level")) {
                    Text("Easy").tag(0)
                    Text("Medium").tag(1)
                    Text("Hard").tag(2)
                }
            }
        }
        label: {
            //  clipboard.fill
            Label("Menu", systemImage: "info.circle.fill")
                .imageScale(.large)
        }
    }
}

extension GameListView {
    class ViewModel: ObservableObject {

        var games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory]

    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Dismiss Me") {
            dismiss()
        }
    }
}
