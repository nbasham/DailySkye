import SwiftUI

struct GamePage: View {
    @ObservedObject var viewModel: GamePageViewModel
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
        .sheet(isPresented: $showHelp, content: { viewModel.showHelp() })
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
                if viewModel.showShareMenu {
                    shareMenuView()
                } else {
                    menuView()
                }
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

    private func shareMenuView() -> some View {
        Button(action: { viewModel.showShare = true }, label: {
            HStack {
                Text("share")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                Image(systemName: "square.and.arrow.up.fill")
                    .imageScale(.large)
            }
        })
    }
}

struct GamePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GamePage(viewModel: GamePageViewModel(game: .cryptogram))
        }
        .previewInterfaceOrientation(.landscapeRight)
    }
}
