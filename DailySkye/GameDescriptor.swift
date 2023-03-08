import SwiftUI

enum GameDescriptor: String, Identifiable {

    case cryptogram, crypto_families, quotefalls, sudoku, word_search, memory

    static let all: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory]

    var displayName: String {
        var name: String
        switch self {
            case .cryptogram:
                name = "Cryptogram"
            case .crypto_families:
                name = "Crypto-Families"
            case .quotefalls:
                name = "Quotefalls"
            case .sudoku:
                name = "Sudoku"
            case .word_search:
                name = "Word Search"
            case .memory:
                name = "Memory"
        }
        return name
    }

    var id: String { self.rawValue }

    var color: Color {
        switch self {
            case .cryptogram:
                return .red
            case .crypto_families:
                return .yellow
            case .quotefalls:
                return .green
            case .sudoku:
                return .blue
            case .word_search:
                return .pink
            case .memory:
                return .purple
        } // next color ff00ff
    }

}
