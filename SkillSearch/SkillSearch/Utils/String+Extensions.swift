import Foundation

extension String {
    
    static let empty = ""
    
    /// Returns a localized string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
