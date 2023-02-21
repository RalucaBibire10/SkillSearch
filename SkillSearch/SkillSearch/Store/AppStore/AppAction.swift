import SwiftUI
import FirebaseAuth

enum AppAction {
    case toggleIsActive
    case toggleAnimate
    
    case resetStates
    case navigationUpdated(screen: Screen?)
    case navigateBack
    case resetNavigation
    
    case login(user: User)
    
    case registerAction(RegisterAction)
    case loginAction(LoginAction)
    case resetPasswordAction(ResetPasswordAction)
    case homeAction(HomeAction)
    case myProfileAction(MyProfileAction)
    
    case fetchCurrentUser(user: UserWithData)
    case updateProfilePicture(data: Data)
    
    case updateUser
}
