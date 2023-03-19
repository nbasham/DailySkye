import Foundation

class PuzzleService {
    func puzzle(id: String? = PuzzleService.calcId, game: GameDescriptor) -> Puzzle {
        let lines = PuzzleService.lines(from: "\(game.id)_puzzles")
        let line = lines.first { str in
            str.starts(with: "0328")
        }
        guard let line = line else { fatalError() }
        switch game {
            default:
                return SamplePuzzle(line: line)
        }
    }

    private static var calcId: String {
        let dc = Calendar.current.dateComponents([.month, .day], from: Date())
        let day = String(format: "%02d", dc.day!)
        let month = String(format: "%02d", dc.month!)
        return "\(month)\(day)"
    }

    private static func lines(from file: String) -> [String] {
        if let path = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                return lines
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return []
    }
}
