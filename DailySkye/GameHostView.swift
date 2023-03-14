import SwiftUI

struct GameHostView: View {
    let game: GameDescriptor
    @State var showHelp: Bool = false
    @State private var isSolved = false

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            ZStack {
                Color.clear
                VStack(spacing: 0) {
                    GeometryReader { proxy in
                        GameView(game: game, size: proxy.size)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    isSolved.toggle()
                                }
                            }
                    }
                    if isSolved {
                        GameSolvedView(game: game)
                            .frame(height: 88)
                            .transition(.move(edge: .bottom))
                    }
                }
           }
        }
        .sheet(isPresented: $showHelp, content: { HelpView() })
        .navigationBarTitle(game.displayName, displayMode: .inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(game.color, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                menuView()
            }
        }
   }

    private func menuView() -> some View {
        Menu {
            Button("Help", action: { showHelp = true } )
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

        init(game: GameDescriptor, delegate: GameService? = nil) {
            self.game = game
            self.delegate = delegate
        }

        private func solved() {
            delegate?.solved()
        }
    }
}

struct GameHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameHostView(game: GameDescriptor.cryptogram)
        }
        .previewInterfaceOrientation(.landscapeRight)
    }
}
