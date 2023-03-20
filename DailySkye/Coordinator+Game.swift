import SwiftUI

protocol GameService: AnyObject {
    func back()
    func showHelp(_ game: GameDescriptor)
    func hideHelp()
    func startGame()
    func startAgain()
    func pause()
    func resume()
    func almostSolve()
    func solveRequest()
    func solved()
    func didSolve(_ game: GameDescriptor)
    func puzzle() -> Puzzle
}

struct GameServices {
    let timer = SecondsTimer()
    let puzzleService = PuzzleService()
}

extension Coordinator: GameService {

    func back() {
        if !gameViewModel.isSolved && gameViewModel.game == .sample_game {
            GameStateStorage.saveState(game: gameViewModel.game, puzzleId: gameViewModel.puzzle.id, seconds: gameServices.timer.seconds)
        }
        navigationStack.remove(at: 0)
    }

    func startGame() {
        gameServices.timer.start{ time in
            self.gameViewModel?.time = time.timerValue
        }
        let state = GameStateStorage.loadState(game: gameViewModel.game)
        if let state = state {
            gameServices.timer.seconds = state.seconds
            gameViewModel.time = state.seconds.timerValue
        }
    }

    func startAgain() { }

    func pause() {
        gameServices.timer.pause()
    }

    func resume() {
        gameServices.timer.resume()
    }

    func almostSolve() {
        gameViewModel.almostSolve = true
    }

    func solveRequest() {
        gameServices.timer.pause()
    }

    func solved() {
        gameServices.timer.pause()
        GameStateStorage.deleteAllState(for: gameViewModel.game)
        withAnimation {
            gameViewModel?.showSolved.toggle()
        }
    }

    func didSolve(_ game: GameDescriptor) { }

    func puzzle() -> Puzzle {
        guard let viewModel = gameViewModel else { fatalError() }
        return gameServices.puzzleService.puzzle(game: viewModel.game)
    }

    func showHelp(_ game: GameDescriptor) {
        gameServices.timer.pause()
    }

    func hideHelp() {
        gameServices.timer.resume()
    }
}

public extension Int {
    /// 96.timerValue, yeilds "1:36"
    var timerValue: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let timeStr = hours == 0 ? "\(minutes):\(String(format: "%02d", seconds))" : "\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        return timeStr
    }
}
