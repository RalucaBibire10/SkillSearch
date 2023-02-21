import SwiftUI
import ComposableArchitecture

struct ResetPasswordReducer: ReducerProtocol {
    typealias State = ResetPasswordState
    typealias Action = ResetPasswordAction
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
            
        case .emailChanged(let email):
            state.email = email
            return Effect(value: .isFilled)
            
        case .isFilled:
            if !state.email.isEmpty {
                state.isFilled = true
            } else {
                state.isFilled = false
            }
            return .none
            
        case .updateMessage(let message, let isError):
            state.message = message
            state.isError = isError
            return .none
            
        case .navigateBack:
            return .none
        }
    }
}
