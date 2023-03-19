import SwiftUI

class HomePageViewModel: ObservableObject {
    let games: [GameDescriptor]
    weak var delegate: AppService?
    @Published var isSoundOn: Bool = true { didSet { soundOnChanged() } }
    @Published var level: Int = 0 { didSet { levelChanged() } }
    @Published var animateGame: GameDescriptor?
    @Published var animateBall: GameDescriptor?
    @Published var isRotating = false
    @Published var bottomHeight: CGFloat = 72
    @Published var pickerBallVMargin: CGFloat = 4 // should be even
    @Published var logoMargin: CGFloat = 0
    @Published var pickerMargin: CGFloat = 72
    @Published var pickerVMargin: CGFloat = 4
    @Published var nameToBallSpace: CGFloat = 18
    var isPortrait: Bool { UIDevice.current.orientation == .portrait }
    lazy var maxGridHeight = CGFloat(44 * games.count)

    init(games: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory], delegate: AppService? = nil) {
        self.games = games
        self.delegate = delegate
        handleRotation(UIDevice.current.orientation)
    }

    func gameSelected(_ game: GameDescriptor) {
        startGameSelectedAnimation(game) {
            self.delegate?.gamePicked(game)
        }
    }

    func handleRotation(_ orientation: UIDeviceOrientation) {
        //  for some reason an occasional .unknow is received
        guard orientation != .unknown else { return }
        logoMargin = orientation == .portrait ? 124 : 200
        pickerMargin = orientation == .portrait ? 0 : logoMargin - 172
        bottomHeight = orientation == .portrait ? 144 : 60
        pickerVMargin = orientation == .portrait ? 8 : 2
        pickerBallVMargin = orientation == .portrait ? 4 : 2
        nameToBallSpace = orientation == .portrait ? 12 : 18
    }

    private func soundOnChanged() {
        delegate?.playSounds(isSoundOn)
    }

    private func levelChanged() {
        delegate?.setLevel(level)
    }
}

//  Animation
extension HomePageViewModel {
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
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + gameDuration + ballDuration) {
            withAnimation {
                self.animateBall = nil
                self.isRotating = false
            }
        }
    }
}
