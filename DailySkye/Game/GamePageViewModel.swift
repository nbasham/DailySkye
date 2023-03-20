import SwiftUI

class GamePageViewModel: ObservableObject {
    let game: GameDescriptor
    weak var delegate: GameService?
    @Published var isSolved = false
    @Published var showSolved = false
    @Published var showShareMenu = false
    @Published var showShare = false
    @Published var showPauseButton = true
    @Published var showRusumeButton = false
    @Published var almostSolve = false
    @Published var time: String = 0.timerValue

    init(game: GameDescriptor, delegate: GameService? = nil) {
        self.game = game
        self.delegate = delegate
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    func startEventListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    func stopEventListening() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }

    func startGame() {
        isSolved = false
        showShareMenu = false
        showPauseButton = true
        delegate?.startGame()
    }

    func pause() {
        withAnimation {
            showRusumeButton = true
            showPauseButton = false
        }
        delegate?.pause()
    }

    func resume() {
        guard !isSolved else { return }
        delegate?.resume()
        withAnimation {
            showRusumeButton = false
            showPauseButton = true
        }
    }

    func solved() {
        withAnimation {
            isSolved = true
            if game.canSharePuzzle {
                showShareMenu = true
            }
        }
        delegate?.solved()
    }

    func showHelp() -> some View {
        delegate?.showHelp(game)
        return HelpView(game: game, completion: hideHelp)
    }

    @ViewBuilder
    func showShareView() -> some View {
        //delegate?.showShare(get puzzle as string or image)
        if let content = puzzle.sharedContent {
            ShareView(shareContent: content)
        }
    }

    func hideHelp() {
        delegate?.hideHelp()
    }

    var puzzle: Puzzle {
        guard let d = delegate else { fatalError() }
        return d.puzzle()
    }

    @objc func appBecameActive() {
        print("App became active")
        delegate?.resume()
    }

    @objc func appMovedToBackground() {
        print("App moved to background!")
        delegate?.pause()
    }
}
