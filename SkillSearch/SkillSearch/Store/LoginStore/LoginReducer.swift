import SwiftUI
import ComposableArchitecture

struct LoginReducer: ReducerProtocol {
    typealias State = LoginState
    typealias Action = LoginAction
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
            
        case .emailChanged(let email):
            state.email = email
            return Effect(value: .isFilled)
            
        case .passwordChanged(let password):
            state.password = password
            return Effect(value: .isFilled)
            
        case .isFilled:
            if !state.email.isEmpty,
               !state.password.isEmpty {
                state.isFilled = true
            } else {
                state.isFilled = false
            }
            
            return .none
            
        case .logIn(let user):
            state.user = user
            return .none
            
        case .updateUserData(let snapshot):
            state.userWithData = UserWithData(snapshot: snapshot)
            return .none
            
        case .updateError(let error):
            state.error = error
            return .none
            
        case .goToResetPasswordScreen:
            return .none
            
        case .navigateBack:
            return .none
        }
    }
}
