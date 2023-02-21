import SwiftUI
import ComposableArchitecture

struct HomeReducer: ReducerProtocol {
    typealias State = HomeState
    typealias Action = HomeAction
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .none:
            return .none
            
        case .updateUserPicture(let user, let data):
            state.usersImageData[user] = data
            return .none
            
        case .fetchUser(let user):
            if user.uid != FirebaseClient.currentUser?.uid && !state.users.contains(where: {$0.uid == user.uid}) {
                state.users.append(user)
                state.filteredUsers.append(user)
            }
            return .none
            
        case .showAlert(let value):
            state.showAlert = value
            return .none
            
        case .logOut:
            state.showAlert = false
            FirebaseClient.logOut()
            return .none
            
        case .filterTextChanged(let text):
            state.filterText = text
            return Effect(value: .filterUsers)
        
        case .filterUsers:
            let lowercasedFilter = state.filterText.lowercased()
            if state.filterText != .empty {
                state.filteredUsers = state.users.filter {
                    $0.name.lowercased().contains(lowercasedFilter) ||
                    $0.skills.contains(where: { $0.lowercased().contains(lowercasedFilter)} )
                }
            } else {
                state.filteredUsers = state.users
            }
            return .none
            
        case .navigateBack:
            state.selectedUser = nil
            state.selectedUserImageData = nil
            return .none
            
        case .selectUser(let user, let data):
            state.selectedUser = user
            state.selectedUserImageData = data
            return .none
            
        case .goToUserProfile:
            return .none
            
        case .setCurrentUser:
            return .none
        }
    }
}
