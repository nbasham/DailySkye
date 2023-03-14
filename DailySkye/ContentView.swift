//
//  ContentView.swift
//  DailySkye
//
//  Created by Norman Basham on 3/7/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coordinator: Coordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            coordinator.start()
                .navigationDestination(for: GameDescriptor.self) { game in
                    coordinator.startGame(game)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
