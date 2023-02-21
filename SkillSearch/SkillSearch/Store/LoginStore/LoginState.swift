import SwiftUI
import FirebaseAuth

public struct LoginState: Equatable {
    var isFilled = false
    
    var email: String = .empty // ""
    var password: String = .empty // ""
    
    var error: String = .empty // ""
    
    var user: User?
    var userWithData: UserWithData?
}
