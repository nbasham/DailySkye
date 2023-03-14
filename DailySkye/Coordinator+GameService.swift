import Foundation

protocol GameService: AnyObject {
    func back()
    func showHelp()
    func startAgain()
    func solveRequest()
    func solved()
    func didSolve(_ game: GameDescriptor)
}

extension Coordinator: GameService {
    func back() {

    }

    func startAgain() {

    }

    func solveRequest() {

    }

    func solved() {

    }

    func didSolve(_ game: GameDescriptor) {
        
    }

}
