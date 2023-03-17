import SwiftUI

class HomePageViewModel: ObservableObject {
    let games: [GameDescriptor]
    weak var delegate: AppService?
    @Published var isSoundOn: Bool = true { didSet { soundOnChanged() } }
    @Published var level: Int = 0 { didSet { levelChanged() } }
    @Published var animateGame: GameDescriptor?
    @Published var animateBall: GameDescriptor?
    @Published var isRotating = false
    let bottomHeight: CGFloat = 72

    init(games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory], delegate: AppService? = nil) {
        self.games = games
        self.delegate = delegate
    }

    func gameSelected(_ game: GameDescriptor) {
        startGameSelectedAnimation(game) {
            self.delegate?.gamePicked(game)
            //                self.coordinator.gameSelected(game)
        }
    }

    func rowHeight(size: CGSize) -> CGFloat {
        var h: CGFloat = 44
        let fillHeight = floor(size.height / Double(games.count))
        guard fillHeight > 0 else { return h }
        if fillHeight > 54 {
            h = 54
        } else {
            h = fillHeight
        }
        return h
    }

    func startGameSelectedAnimation(_ game: GameDescriptor, completion: @escaping () -> ()) {
        let gameDuration = 0.2
        let ballDuration = 1.05
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
            completion()
            //                self.navigationStack.append(game)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + gameDuration + ballDuration) {
            withAnimation {
                self.animateBall = nil
                self.isRotating = false
            }
        }
    }

    private func soundOnChanged() {
        delegate?.playSounds(isSoundOn)
    }

    private func levelChanged() {
        delegate?.setLevel(level)
    }
    }
