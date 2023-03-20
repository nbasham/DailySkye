import SwiftUI

struct SampleView: View {
    @ObservedObject var viewModel: GamePageViewModel
    @EnvironmentObject var settings: Settings
    private var puzzle: SamplePuzzle {
        viewModel.puzzle as! SamplePuzzle
    }

    var body: some View {
        ZStack(alignment: .center) {
            viewModel.game.color.opacity(0.5)
            VStack {
                Text("\(puzzle.author)")
                Text("\(puzzle.quote)")
                Text("\(viewModel.time)")
                Text("almostSolve: \(viewModel.almostSolve ? "true" : "false")")
                Text("Test publish, use menu: sound on \(settings.soundOn ? "true" : "false")")
                Button(action: {
                    withAnimation {
                        viewModel.almostSolve = true
                    }
                }, label: {
                    Text("Almost solve")
                })
                if viewModel.showPauseButton {
                    Button(action: {
                        withAnimation {
                            viewModel.pause()
                        }
                    }, label: {
                        Text("Pause game")
                    })
                }
                if viewModel.showRusumeButton {
                    Button(action: {
                        withAnimation {
                            viewModel.resume()
                        }
                    }, label: {
                        Text("Resume game")
                    })
                }
                Button(action: {
                    withAnimation {
                        viewModel.solved()
                    }
                }, label: {
                    Text("Solve game")
                })
            }
            .padding()
        }
        .onAppear {
            viewModel.startGame()
        }
    }
}

extension SampleView {
    class ViewModel: ObservableObject {

    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView(viewModel: GamePageViewModel(game: .sample_game))
            .environmentObject(Settings())
    }
}
