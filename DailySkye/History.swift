import Foundation

class History {
    private static func key(game: GameDescriptor) -> String {
        "\(Date.yyddmm)_\(game.id)_completed"
    }

    static func completed(game: GameDescriptor) {
        UserDefaults.standard.set(true, forKey: key(game: game))
    }

    static func isCompleted(game: GameDescriptor) -> Bool {
        UserDefaults.standard.value(forKey: key(game: game)) != nil
    }

    static func allCompleted(games: [GameDescriptor]) -> Bool {
        for game in games {
            if !isCompleted(game: game) {
                return false
            }
        }
        return false
    }
}
