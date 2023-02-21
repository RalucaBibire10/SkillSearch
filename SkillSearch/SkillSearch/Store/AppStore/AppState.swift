import SwiftUI
import PhotosUI
import FirebaseAuth

public struct AppState: Equatable {
    var animate = false
    var isActive = false
    
    var isUserSet = false
    var user: User? = FirebaseClient.currentUser
    var userWithData: UserWithData?
    var imageData: Data?
    
    var registerState = RegisterState()
    var loginState = LoginState()
    var resetPasswordState = ResetPasswordState()
    var homeState = HomeState()
    var myProfileState = MyProfileState()
    
    public var navigationPath: [Screen] = []
}

public enum Screen: Hashable {
    case register
    case login
    case home
    case welcome
    case forgotPassword
    case userDetails
    case myProfile
}
