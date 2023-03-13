import SwiftUI

protocol AppService: AnyObject {
    func showContact()
    func showHelp()
    func gamePicked(_ game: GameDescriptor)
    func playSounds(_ play: Bool)
    func showTimer(_ show: Bool)
    func setLevel(_ level: Int)
}

protocol GameService {
    func back()
    func showHelp()
    func startAgain()
    func solveRequest()
    func didSolve(_ game: GameDescriptor)
}

//  Coordinator+AppService
extension Coordinator: AppService {
    func showContact() {  }

    func showHelp() { }

    func gamePicked(_ game: GameDescriptor) {
        navigationStack.append(game)
    }

    func playSounds(_ play: Bool) { }
    func setLevel(_ level: Int) {
        print("level \(level)")
    }
    func showTimer(_ show: Bool) { }


}
class Coordinator: ObservableObject {
    @Published var navigationStack: [GameDescriptor] = []
    private var gamePickerViewModel = GamePicker.ViewModel()

    func start() -> some View {
        let games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory]
        gamePickerViewModel = GamePicker.ViewModel(games: games, delegate: self)
        return GamePicker(viewModel: gamePickerViewModel)
    }
}
