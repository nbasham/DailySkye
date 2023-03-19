import SwiftUI

class GamePageViewModel: ObservableObject {
    let game: GameDescriptor
    weak var delegate: GameService?
    @Published var isSolved = false
    @Published var showSolved = false
    @Published var showShareMenu = false
    @Published var showShare = false
    @Published var time: String = 0.timerValue

    init(game: GameDescriptor, delegate: GameService? = nil) {
        self.game = game
        self.delegate = delegate
    }

    func startGame() {
        isSolved = false
        showShareMenu = false
        delegate?.startGame()
    }

    func pause() {
        delegate?.pause()
    }

    func resume() {
        guard !isSolved else { return }
        delegate?.resume()
    }

    func solved() {
        withAnimation {
            isSolved = true
        }
        if game.canSharePuzzle {
            showShareMenu = true
        }
        delegate?.solved()
    }

    func showHelp() -> some View {
        delegate?.showHelp(game)
        return HelpView(game: game, completion: hideHelp)
    }

    func hideHelp() {
        delegate?.hideHelp()
    }

    var puzzle: Puzzle {
        guard let d = delegate else { fatalError() }
        return d.puzzle()
    }
}
