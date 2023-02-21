import SwiftUI

private enum ColorLiteral {
    case appGreen
    case lightGray
    case darkGray
    case darkRed
    
    var name: String{ String(describing: self) }
}

private extension Color {
    init(_ asset: ColorLiteral) {
        self.init(asset.name, bundle: .main)
    }
}

public extension Color {
    static let appGreen = Color(.appGreen)
    static let lightGray = Color(.lightGray)
    static let darkGray = Color(.darkGray)
    static let darkRed = Color(.darkRed)
}
