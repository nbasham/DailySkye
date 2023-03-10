//
//  GameSolvedView.swift
//  DailySkye
//
//  Created by Norman Basham on 3/10/23.
//

import SwiftUI

struct GameSolvedView: View {
    let game: GameDescriptor

    var body: some View {
        ZStack {
            game.color
        }
        .ignoresSafeArea()
    }
}

struct GameSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        GameSolvedView(game: .memory)
    }
}
