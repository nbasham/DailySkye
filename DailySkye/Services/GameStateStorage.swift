import UIKit

struct GameState: Codable {
    let puzzleId: String
    let seconds: Int
}

/*
 TODO
 add delete all state to clear previous games
 add delete to clear after solved\\
 */


class GameStateStorage {

    static func loadState(game: GameDescriptor) -> GameState? {
        return GameStateStorage.load(key: GameStateStorage.key(for: game))
    }

    static func deleteState(game: GameDescriptor, defaults: UserDefaults = UserDefaults.standard) {
        defaults.removeObject(forKey: GameStateStorage.key(for: game))
    }

    static func deleteAllState(for game: GameDescriptor, defaults: UserDefaults = UserDefaults.standard) {
        let dictionary = defaults.dictionaryRepresentation()
        let str = "\(game.id)_state"
        dictionary.keys.forEach { key in
            if key.contains(str) {
                defaults.removeObject(forKey: key)
            }
        }
    }

    static func saveState(game: GameDescriptor, puzzleId: String, seconds: Int) {
        let state = GameState(puzzleId: puzzleId, seconds: seconds)
        GameStateStorage.save(value: state, key: GameStateStorage.key(for: game))
    }

    private static func key(for game: GameDescriptor) -> String {
        "\(Date.ddmm)_\(game.id)_state"
    }

    private static func load<T: Decodable>(key: String, defaults: UserDefaults = UserDefaults.standard) -> T? {
        if let data = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let obj = try? decoder.decode(T.self, from: data) {
                return obj
            }
        }
        return nil
    }

    private static func save<T: Encodable>(value: T, key: String, defaults: UserDefaults = UserDefaults.standard) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: key)
        }
    }
}
