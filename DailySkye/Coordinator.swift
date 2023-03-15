import SwiftUI

class Coordinator: ObservableObject {
    let settings: Settings = Settings()
    @Published var navigationStack: [GameDescriptor] = []
    internal var gamePickerViewModel = HomePage.ViewModel()
    internal var gameViewModel: GamePage.ViewModel?

    func start() -> some View {
        let games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory]
        gamePickerViewModel = HomePage.ViewModel(games: games, delegate: self)
        return HomePage(viewModel: gamePickerViewModel).environmentObject(settings)
    }

    func startGame(_ game: GameDescriptor) -> some View {
        gameViewModel = GamePage.ViewModel(game: game, delegate: self)
        return GamePage(viewModel: gameViewModel!).environmentObject(settings)
    }
}
