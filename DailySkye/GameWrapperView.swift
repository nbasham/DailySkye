import SwiftUI

struct GameWrapperView: View {
    let game: GameDescriptor
    @State var showHelp: Bool = false

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            GeometryReader { proxy in
                GameView(game: game, size: proxy.size)
            }
        }
        .sheet(isPresented: $showHelp, content: { HelpView() })
        .navigationBarTitle(game.displayName, displayMode: .inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color("top"), for: .navigationBar)
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

struct GameWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameWrapperView(game: GameDescriptor.cryptogram)
        }
        .previewInterfaceOrientation(.landscapeRight)
    }
}
