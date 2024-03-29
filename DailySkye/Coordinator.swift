import SwiftUI

class Coordinator: ObservableObject {
    let settings: Settings = Settings()
    @Published var navigationStack: [GameDescriptor] = []
    internal var gamePickerViewModel = HomePageViewModel()
    internal var gameViewModel: GamePageViewModel!
    internal let gameServices = GameServices()
    internal var currentGame: GameAPI?
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    func start(_ proxy: GeometryProxy? = nil) -> some View {
        //  for now keep these, using proxy here forces ContentView to redraw on rotation
//        print(proxy!.safeAreaInsets)
//        print(safeAreaInsets.wrappedValue)
        let games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory, .triplets, .sample_game]
        gamePickerViewModel = HomePageViewModel(games: games, delegate: self)
        return HomePage(viewModel: gamePickerViewModel, safeAreaInsets: proxy!.safeAreaInsets)
            .environmentObject(settings)

    }

    func startGame(_ game: GameDescriptor) -> some View {
        gameViewModel = GamePageViewModel(game: game, delegate: self)
        return GamePage(viewModel: gameViewModel!).environmentObject(settings)
    }
}
