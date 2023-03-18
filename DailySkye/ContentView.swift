//
//  ContentView.swift
//  DailySkye
//
//  Created by Norman Basham on 3/7/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coordinator: Coordinator = Coordinator()
    @State var safeAreaInsets = EdgeInsets()

    var body: some View {
        GeometryReader { proxy in
            NavigationStack(path: $coordinator.navigationStack) {
                coordinator.start(proxy)
                    .navigationDestination(for: GameDescriptor.self) { game in
                        coordinator.startGame(game)
                    }
                    .environment(\.safeAreaInsets, $safeAreaInsets)
            }
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

//  Use a binding so that we can set the value if it changes e.g. rotation
private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: Binding<EdgeInsets> {
        .constant(UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets())
    }
}

extension EnvironmentValues {
    var safeAreaInsets: Binding<EdgeInsets> {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
