import SwiftUI

struct GamePicker: View {
    @ObservedObject var viewModel: GamePicker.ViewModel
    @State var showHelp: Bool = false
    private let bottomHeight: CGFloat = 72

    var body: some View {
        VStack(spacing: 0) {
            middleView
            bottomView
        }
        .navigationBarTitle("") // hides Back on game screen
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color("top"), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    Color.clear
                        .frame(width: 200)
                    logoView
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                menuView()
            }
        }
        .sheet(isPresented: $showHelp, content: { HelpView() })
    }

    private var middleView: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            ZStack {
                Color("background")
                gridView()
                    .zIndex(2)
            }
        }
    }

    private var bottomView: some View {
        ZStack(alignment: .leading) {
            Color("top").opacity(0.5)
                .ignoresSafeArea()
                .frame(height: bottomHeight)
            HStack(spacing: 0) {
                Circle()
                    .foregroundColor(Color("top"))
                    .offset(x: -bottomHeight/2.0)
                    .ignoresSafeArea()
                    .frame(height: bottomHeight)
                factioidView()
                    .frame(maxHeight: 66)
            }
            //  TODO Need a solution that leaves the trailing margin in tact
            .offset(x: -bottomHeight/2.0)
        }
    }

    private var logoView: some View {
        HStack(spacing: 2) {
            Text("Daily")
                .fontWeight(.light)
            Text("Puzzles")
                .fontWeight(.heavy)
        }
        .font(.system(size: 19))
    }

    private func gridView() -> some View {
        GeometryReader { proxy in
            Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 4) {
                ForEach(viewModel.games, id: \.id) { game in
                    GamePickerRowView(game: game, viewModel: viewModel, height: floor(proxy.size.height / Double(viewModel.games.count)) - 4)
                }
//                .environmentObject(coordinator)
            }
        }
        .padding(.top, 4)
        .padding(.leading, 90)
    }

    private func factioidView() -> some View {
        let message: LocalizedStringKey = """
        Visit Apple: [click here](https://apple.com) This is **bold** text, this is *italic* text, and this is ***bold, italic*** text. ~~A strikethrough example~~ `Monospaced works too` 🙃 I recently befriended my neighbor and who is my dad’s age and in a wheelchair. He is so lonely because his wife died right around the time he lost his second leg.
        """
        return Text(message).minimumScaleFactor(0.1).padding(.top, 8)
    }

    private func menuView() -> some View {
        Menu {
            Button("Help", action: { showHelp = true })
            Menu("Play sounds") {
                Picker(selection: $viewModel.isSoundOn, label: Text("")) {
                    Text("No").tag(0)
                    Text("Yes").tag(1)
                }
            }
            Menu("Level") {
                Picker(selection: $viewModel.level, label: Text("Level")) {
                    Text("Easy").tag(0)
                    Text("Medium").tag(1)
                    Text("Hard").tag(2)
                }
            }
        }
        label: {
            //  clipboard.fill
            Label("Menu", systemImage: "info.circle.fill")
                .imageScale(.large)
        }
    }
}

extension GamePicker {
    class ViewModel: ObservableObject {
        let games: [GameDescriptor]
        weak var delegate: AppService?
        @Published var isSoundOn: Bool = true { didSet { soundOnChanged() } }
        @Published var level: Int = 0 { didSet { levelChanged() } }
        @Published var animateGame: GameDescriptor?
        @Published var animateBall: GameDescriptor?
        @Published var isRotating = false

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
}

struct GamePicker_Previews: PreviewProvider {
    static var previews: some View {
        GamePicker(viewModel: GamePicker.ViewModel())
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Dismiss Me") {
            dismiss()
        }
    }
}
