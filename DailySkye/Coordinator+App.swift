import Foundation

protocol AppService: AnyObject {
    func showContact()
    func showHelp()
    func gamePicked(_ game: GameDescriptor)
    func playSounds(_ play: Bool)
    func showTimer(_ show: Bool)
    func setLevel(_ level: Int)
}

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
