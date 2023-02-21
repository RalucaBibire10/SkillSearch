import SwiftUI
import FirebaseAuth

public struct ResetPasswordState: Equatable {
    var isFilled = false
    
    var email: String = .empty
    
    var message: String = .empty
    var isError = false
}
