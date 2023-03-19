import SwiftUI

struct GamePage: View {
    @ObservedObject var viewModel: GamePage.ViewModel
    @State var showHelp: Bool = false
    @EnvironmentObject var settings: Settings

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            ZStack {
                Color.clear
                VStack(spacing: 0) {
                    GeometryReader { proxy in
                        switch(viewModel.game) {
                            case .sample_game:
                                SampleView(viewModel: viewModel)
                            default:
                                GameView(viewModel: viewModel, size: proxy.size)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.solved()
                                        }
                                    }
                        }
                    }
                    if viewModel.showSolved {
                        GameSolvedView(viewModel: viewModel)
                            .frame(height: 88)
                            .transition(.move(edge: .bottom))
                    }
                }
           }
        }
        .sheet(isPresented: $showHelp, content: { HelpView() })
        .navigationBarTitle(viewModel.game.displayName, displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(viewModel.game.color, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    Button(action: {
                        viewModel.delegate?.back()
                    }, label: {
                        HStack {
                            Label("back", systemImage: "chevron.left.circle.fill")
                                .imageScale(.large)
                            Text("back")
                                .foregroundColor(.white)
                                .fontWeight(.light)
                        }
                    })
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                menuView()
            }
        }
   }

    private func menuView() -> some View {
        Menu {
            Button("Help", action: { showHelp = true } )
            Button("Toggle settings soundOn", action: { settings.soundOn.toggle() } )
        }
        label: {
            HStack {
                Text("menu")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                Label("menu", systemImage: "info.circle.fill")
                    .imageScale(.large)
            }
        }
    }

}

extension GamePage {
    class ViewModel: ObservableObject {
        let game: GameDescriptor
        weak var delegate: GameService?
        @Published var showSolved = false
        @Published var time: String = 0.timerValue

        init(game: GameDescriptor, delegate: GameService? = nil) {
            self.game = game
            self.delegate = delegate
        }

        func startGame() {
            delegate?.startGame()
        }

        func pause() {
            delegate?.pause()
        }

        func resume() {
            delegate?.resume()
        }

        func solved() {
            delegate?.solved()
        }

        var puzzle: Puzzle {
            guard let d = delegate else { fatalError() }
            return d.puzzle()
        }
    }
}

struct GamePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GamePage(viewModel: GamePage.ViewModel(game: .cryptogram))
        }
        .previewInterfaceOrientation(.landscapeRight)
    }
}

struct SudokuView: View {
    @ObservedObject var viewModel: GamePage.ViewModel
    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack {
            Text("sound on \(settings.soundOn ? "true" : "false")")
            Button(action: {
                withAnimation {
                    viewModel.solved()
                }
            }, label: {
                Text("Solve it")
            })
        }
    }
}
