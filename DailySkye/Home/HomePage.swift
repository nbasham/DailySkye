import SwiftUI

struct HomePage: View {
    @ObservedObject var viewModel: HomePageViewModel
    @State var showHelp: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            middleView
            bottomView
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // it is OK to update @Published vars here
            viewModel.handleRotation(UIDevice.current.orientation)
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
                        .frame(width: viewModel.logoMargin)
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
                VStack(spacing: 0) {
                    Spacer(minLength: viewModel.pickerVMargin)
                    gridView()
                        .zIndex(2)
                    Spacer(minLength: viewModel.pickerVMargin)
                }
            }
        }

    }

    private var bottomView: some View {
        ZStack(alignment: .leading) {
            Color("top").opacity(0.5)
                .ignoresSafeArea()
                .frame(height: viewModel.bottomHeight)
            HStack(spacing: 0) {
                Circle()
                    .foregroundColor(Color("top"))
                    .offset(x: -viewModel.bottomHeight/2.0)
                    .ignoresSafeArea()
                    .frame(height: viewModel.bottomHeight)
                factioidView()
                    .frame(maxHeight: viewModel.bottomHeight - 8)
            }
            //  TODO Need a solution that leaves the trailing margin in tact
            .offset(x: -viewModel.bottomHeight/2.0)
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
            Grid(alignment: .leading, horizontalSpacing: viewModel.nameToBallSpace, verticalSpacing: viewModel.pickerBallVMargin) {
                ForEach(viewModel.games, id: \.id) { game in
                    HomeGamePickerRowView(game: game, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 2)
            .frame(maxHeight: viewModel.maxGridHeight)
       }
        .padding(.leading, viewModel.pickerMargin)
    }

    private func factioidView() -> some View {
        let message: LocalizedStringKey = """
        Visit Apple: [click here](https://apple.com) This is **bold** text, this is *italic* text, and this is ***bold, italic*** text. ~~A strikethrough example~~ `Monospaced works too` 🙃 I recently befriended my neighbor and who is my dad’s age and in a wheelchair. He is so lonely because his wife died right around the time he lost his second leg.
        """
        return Text(message).minimumScaleFactor(0.1).padding(.horizontal, 0).padding(.top, 8)
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

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomePage(viewModel: HomePageViewModel())
        }
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var game: GameDescriptor?
    var completion: (() -> Void)?

    var body: some View {
        Button("Dismiss Me") {
            dismiss()
            completion?()
        }
    }
}
