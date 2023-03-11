//
//  ContentView.swift
//  DailySkye
//
//  Created by Norman Basham on 3/7/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GamePicker()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
