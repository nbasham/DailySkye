//
//  GameSolvedView.swift
//  DailySkye
//
//  Created by Norman Basham on 3/10/23.
//

import SwiftUI

struct GameSolvedView: View {
    @ObservedObject var viewModel: GamePage.ViewModel

    var body: some View {
        ZStack {
            viewModel.game.color
        }
        .ignoresSafeArea()
    }
}

struct GameSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        GameSolvedView(viewModel: GamePage.ViewModel(game: .cryptogram))
    }
}
