import SwiftUI

class Settings: ObservableObject {
    // Get app storage and published behavior!
    @AppStorage("soundOn") var soundOn: Bool = true {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}

