import SwiftUI
import FirebaseAuth

public struct HomeState: Equatable {
    var currentUser: User?
    var currentUserData: UserWithData?
    var imageData: Data?
    
    var users = [UserWithData]()
    var usersImageData = [String: Data]()
    
    var filterText: String = .empty
    var filteredUsers = [UserWithData]()
    
    var showAlert = false
    
    var selectedUser: UserWithData?
    var selectedUserImageData: Data?
}
