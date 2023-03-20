import UIKit

extension Date {
    static var yyddmm: String {
        Date().yyddmm
    }
    
    var yyddmm: String {
        let dc = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let day = String(format: "%02d", dc.day!)
        let month = String(format: "%02d", dc.month!)
        let year = String(format: "%02d", dc.year!)
        return "\(year)\(month)\(day)"
    }

    static var ddmm: String {
        Date().ddmm
    }

    private var ddmm: String {
        let dc = Calendar.current.dateComponents([.month, .day], from: self)
        let day = String(format: "%02d", dc.day!)
        let month = String(format: "%02d", dc.month!)
        return "\(month)\(day)"
    }
}

extension UIColor {
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0

        // Extract r,g,b,a components from the
        // current UIColor
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )

        // Create a new UIColor modifying each component
        // by componentDelta, making the new UIColor either
        // lighter or darker.
        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
}

extension UIColor {
    // Add value to component ensuring the result is
    // between 0 and 1
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
}

extension UIColor {
    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }

    func darker(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*componentDelta)
    }
}
