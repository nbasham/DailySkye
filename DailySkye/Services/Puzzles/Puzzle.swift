import Foundation

class Puzzle: Identifiable {
    let id: String
    /// This is where a puzzle can be formatted to be shared with others e.g. via Twiter
    var sharedContent: String? { nil }

    init(id: String) {
        self.id = id
    }
}
