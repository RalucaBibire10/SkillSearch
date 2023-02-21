import SwiftUI
import FirebaseAuth
import FirebaseDatabase

public enum LoginAction {    
    case emailChanged(to: String)
    case passwordChanged(to: String)
    
    case isFilled
    
    case updateError(to: String)
    case logIn(User)
    case updateUserData(from: DataSnapshot)
    
    case goToResetPasswordScreen
    case navigateBack
}
