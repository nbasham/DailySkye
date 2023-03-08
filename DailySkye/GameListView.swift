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
                    listView()
                }
                Color.brown
                    .ignoresSafeArea()
                    .frame(height: viewModel.bottomHeight)
            }
            .navigationBarTitle("Daily Puzzles", displayMode: .inline)
            .navigationDestination(for: GameDescriptor.self) { game in
                coordinator.startGame(game)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.brown, for: .navigationBar)
            .toolbar {
                menuView()
            }
            .sheet(isPresented: $showHelp, content: { HelpView() })
        }
    }

    private func listView() -> some View {
        GeometryReader { proxy in
            List {
                ForEach(viewModel.games) { game in
                    GameListRowView(game: game)
                        .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.clear)
                .environmentObject(coordinator)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onAppear {
                viewModel.onAppear(proxy: proxy)
            }
        }
    }

    private func menuView() -> some View {
        Menu("Menu") {
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
    }
}

extension GameListView {
    class ViewModel: ObservableObject {
        @Published var rowHeight: CGFloat = 40
        @Published var bottomHeight: CGFloat = 80

        var games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory]

        func onAppear(proxy: GeometryProxy) {
            rowHeight = proxy.size.width / Double(games.count)
            bottomHeight = UIScreen.main.bounds.width - 44 - proxy.size.width
        }
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
