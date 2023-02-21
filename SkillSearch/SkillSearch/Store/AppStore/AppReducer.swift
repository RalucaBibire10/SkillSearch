import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import ComposableArchitecture

struct AppReducer: ReducerProtocol {
    
    typealias State = AppState
    typealias Action = AppAction
    
    func reduce(into state: inout AppState, action: AppAction) -> ComposableArchitecture.EffectTask<AppAction>
    {
        
        switch action {
            // MARK: - main
            
        case .toggleAnimate:
            state.animate.toggle()
            return .none
            
        case .toggleIsActive:
            state.isActive.toggle()
            return .none
            
        case .resetStates:
            state.registerState = RegisterState()
            state.loginState = LoginState()
            state.resetPasswordState = ResetPasswordState()
            state.homeState = HomeState()
            state.myProfileState = MyProfileState()
            return .none
            
        case .navigationUpdated(let screen):
            if let screen = screen {
                state.navigationPath.append(screen)
            }
            return .none
            
        case .navigateBack:
            _ = state.navigationPath.popLast()
            state.homeState.filteredUsers.removeAll()
            state.homeState.users.removeAll()
            return .none
            
        case .resetNavigation:
            state.navigationPath.removeAll()
            return .none
            
        case .login(let user):
            state.user = user
            return Effect(value: .updateUser)
            
        case .updateUser:
            state.homeState.currentUser = state.user
            return .none
            
        case .fetchCurrentUser(let user):
            state.userWithData = user
            state.homeState.currentUserData = user
            return.none
            
        case .updateProfilePicture(let data):
            state.imageData = data
            state.homeState.imageData = data
            return .none
            
            // MARK: - Register
            
        case .registerAction(.uploadInfo):
            state.user = state.registerState.user
            state.homeState.currentUser = state.user
            state.imageData = state.registerState.imageData
            state.homeState.imageData = state.imageData
            state.isUserSet = true
            return Effect(value: .navigationUpdated(screen: .home))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .registerAction(.uploadImage(_)):
            return Effect(self.body.reduce(into: &state, action: action))
            
        case .registerAction(.navigateBack):
            return Effect(value: .navigateBack)
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .registerAction(_):
            return self.body.reduce(into: &state, action: action)
            
            // MARK: - Login
            
        case .loginAction(.logIn(let user)):
            return Effect(value: .login(user: user))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .loginAction(.updateUserData):
            state.userWithData = state.loginState.userWithData
            return Effect(value: .navigationUpdated(screen: .home))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .loginAction(.goToResetPasswordScreen):
            return Effect(value: .navigationUpdated(screen: .forgotPassword))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .loginAction(.navigateBack):
            return Effect(value: .navigateBack)
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .loginAction(_):
            return self.body.reduce(into: &state, action: action)
            
            // MARK: - Reset Password
            
        case .resetPasswordAction(.navigateBack):
            return Effect(value: .navigateBack)
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .resetPasswordAction(_):
            return self.body.reduce(into: &state, action: action)
            
            // MARK: - Home
            
        case .homeAction(.setCurrentUser):
            if state.isUserSet {
                state.homeState.currentUser = state.user
                state.homeState.currentUserData = state.userWithData
                state.homeState.imageData = state.imageData
            }
            return .none
            
        case .homeAction(.logOut):
            state.isUserSet = false
            state.user = nil
            state.userWithData = nil
            return Effect(value: .resetStates)
                .merge(with: Effect(value: .resetNavigation))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .homeAction(.navigateBack):
            return Effect(value: .navigateBack)
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .homeAction(.selectUser(_, _)):
            return Effect(value: .navigationUpdated(screen: .userDetails))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .homeAction(.goToUserProfile):
            state.myProfileState.imageData = state.homeState.imageData
            let user = state.homeState.currentUserData
            state.myProfileState.currentUserData = user
            state.myProfileState.name = user?.name ?? .empty
            state.myProfileState.skills = user?.skills.joined(separator: ",") ?? .empty
            return Effect(value: .navigationUpdated(screen: .myProfile))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .homeAction(_):
            return self.body.reduce(into: &state, action: action)
            
            // MARK: - My Profile
            
        case .myProfileAction(.navigateBack):
            return Effect(value: .navigateBack)
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .myProfileAction(.logOut):
            state.user = nil
            state.userWithData = nil
            state.isUserSet = false
            return Effect(value: .resetStates)
                .merge(with: Effect(value: .resetNavigation))
                .merge(with: self.body.reduce(into: &state, action: action))
            
        case .myProfileAction(.imageDataChanged(let data)):
            state.homeState.imageData = data
            return self.body.reduce(into: &state, action: action)
            
        case .myProfileAction(.save):
            state.homeState.currentUserData?.name = state.myProfileState.name
            state.homeState.currentUserData?.skills = state.myProfileState.skills.components(separatedBy: ",")
            return Effect(value: .navigateBack)
            
        case .myProfileAction(_):
            return self.body.reduce(into: &state, action: action)
        }
        
    }
    
    @ReducerBuilder<State, Action>
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.registerState, action: /Action.registerAction) {
            RegisterReducer()
        }
        Scope(state: \.loginState , action: /Action.loginAction) {
            LoginReducer()
        }
        Scope(state: \.resetPasswordState , action: /Action.resetPasswordAction) {
            ResetPasswordReducer()
        }
        Scope(state: \.homeState, action: /Action.homeAction) {
            HomeReducer()
        }
        Scope(state: \.myProfileState, action: /Action.myProfileAction) {
            MyProfileReducer()
        }
    }
}

let appReducer = AppReducer()

