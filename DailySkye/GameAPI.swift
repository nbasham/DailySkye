import Foundation

protocol GameAPI {
    /// Optional, if your game has content to be shared once it's solved (e.g. a quote) return it here.
    var sharedContent: String? { get }
    /// User chose Solve from the menu.
    func solveRequest()
    /// User chose Solve from the menu.
    func start()
    /// Optional, for debugging, set your state to a move before completion
    func almostSolve()
}

extension GameAPI {
    var sharedContent: String? { nil }
    func almostSolve() {}
}
