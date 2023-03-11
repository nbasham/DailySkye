import SwiftUI

class Coordinator: ObservableObject {
    @Published var navigationStack: [GameDescriptor] = []
    @Published var isSoundOn: Int = 1 { didSet { soundOnChanged() } }
    @Published var level: Int = 0 { didSet { levelChanged() } }
    @Published var animateGame: GameDescriptor?
    @Published var animateBall: GameDescriptor?
    @Published var isRotating = false

    func startGame(_ game: GameDescriptor) -> some View {
        GameWrapperView(game: game)
    }

    func gameSelected(_ game: GameDescriptor) {
        let gameDuration = 0.2
        let ballDuration = 1.45
        let gameAnimation = Animation.spring(blendDuration: gameDuration)
        withAnimation(gameAnimation) {
            animateGame = game
        }

        let ballAnimation = Animation.easeIn(duration: ballDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + gameDuration) {
            withAnimation(gameAnimation) {
                self.animateGame = nil
            }
            withAnimation(.linear(duration: ballDuration).repeatForever(autoreverses: false)) {
                self.isRotating = true
            }
            withAnimation(ballAnimation) {
                self.animateBall = game
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + gameDuration + ballDuration - 0.2) {
            self.navigationStack.append(game)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + gameDuration + ballDuration) {
            withAnimation {
                self.animateBall = nil
                self.isRotating = false
            }
        }
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
