import SwiftUI

class Coordinator: ObservableObject {
    @Published var navigationStack: [GameDescriptor] = []
    internal var gamePickerViewModel = GamePicker.ViewModel()
    internal var gameViewModel: GameHostView.ViewModel?

    func start() -> some View {
        let games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory]
        gamePickerViewModel = GamePicker.ViewModel(games: games, delegate: self)
        return GamePicker(viewModel: gamePickerViewModel)
    }

    func startGame(_ game: GameDescriptor) -> some View {
        gameViewModel = GameHostView.ViewModel(game: game, delegate: self)
        return GameHostView(viewModel: gameViewModel!)
    }
}
