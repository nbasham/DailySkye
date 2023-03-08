import SwiftUI

class Coordinator: ObservableObject {
    @Published var navigationStack: [GameDescriptor] = []
    @Published var isSoundOn: Int = 1 { didSet { soundOnChanged() } }
    @Published var level: Int = 0 { didSet { levelChanged() } }

    func startGame(_ game: GameDescriptor) -> some View {
        GameWrapperView(game: game)
    }

    func gameSelected(_ game: GameDescriptor) {
        navigationStack.append(game)
    }

    private func soundOnChanged() {
        print("sound on \(["no", "yes"][isSoundOn])")
    }

    private func levelChanged() {
        print("level change \(level)")
    }

    private func help() {
    }
}
