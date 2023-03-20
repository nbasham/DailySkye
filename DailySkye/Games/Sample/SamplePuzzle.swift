import Foundation

class SamplePuzzle: Puzzle {
    let author: String
    let quote: String
    override var sharedContent: String? { "\(quote) - \(author)" }

    init(line: String) {
        let components = line.split(separator: "\t")
        self.author = String(components[1])
        self.quote = String(components[2])
        super.init(id: String(components[0]))
    }
}
