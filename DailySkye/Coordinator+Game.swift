import SwiftUI

protocol GameService: AnyObject {
    func back()
    func showHelp()
    func startGame()
    func startAgain()
    func pause()
    func resume()
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
        navigationStack.remove(at: 0)
    }

    func startGame() {
        gameServices.timer.start{ time in
            self.gameViewModel?.time = time.timerValue
        }
    }

    func startAgain() { }

    func pause() {
        gameServices.timer.pause()
    }

    func resume() {
        gameServices.timer.resume()
    }

    func solveRequest() {
        gameServices.timer.pause()
    }

    func solved() {
        gameServices.timer.pause()
        withAnimation {
            gameViewModel?.showSolved.toggle()
        }
    }

    func didSolve(_ game: GameDescriptor) { }

    func puzzle() -> Puzzle {
        guard let viewModel = gameViewModel else { fatalError() }
        return gameServices.puzzleService.puzzle(game: viewModel.game)
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
