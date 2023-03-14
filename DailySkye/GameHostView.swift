import SwiftUI

struct GameHostView: View {
    @ObservedObject var viewModel: GameHostView.ViewModel
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
                            case .sudoku:
                                SudokuView(viewModel: viewModel)
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
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(viewModel.game.color, for: .navigationBar)
        .toolbar {
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
            Label("Menu", systemImage: "info.circle.fill")
                .imageScale(.large)
        }
    }

}

extension GameHostView {
    class ViewModel: ObservableObject {
        let game: GameDescriptor
        weak var delegate: GameService?
        @Published var showSolved = false

        init(game: GameDescriptor, delegate: GameService? = nil) {
            self.game = game
            self.delegate = delegate
        }

        func solved() {
            delegate?.solved()
        }
    }
}

struct GameHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameHostView(viewModel: GameHostView.ViewModel(game: .cryptogram))
        }
        .previewInterfaceOrientation(.landscapeRight)
    }
}

struct SudokuView: View {
    @ObservedObject var viewModel: GameHostView.ViewModel
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
