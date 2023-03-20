import Foundation

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
