import SwiftUI

public enum ResetPasswordAction {
    case emailChanged(to: String)
    
    case isFilled
    
    case updateMessage(message: String, isError: Bool)
    
    case navigateBack
}
