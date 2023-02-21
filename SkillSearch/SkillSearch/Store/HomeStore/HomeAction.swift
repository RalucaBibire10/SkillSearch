import SwiftUI

enum HomeAction {
    case none
    case showAlert(Bool)
    case logOut
    
    case setCurrentUser
    case updateUserPicture(user: String, data: Data)
    case fetchUser(user: UserWithData)
    
    case filterTextChanged(to: String)
    case filterUsers
    
    case navigateBack
    
    case selectUser(user: UserWithData, data: Data)
    
    case goToUserProfile
}
