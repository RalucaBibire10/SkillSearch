import SwiftUI
import PhotosUI
import FirebaseAuth
import ComposableArchitecture

struct RegisterReducer: ReducerProtocol {
    
    typealias State = RegisterState
    typealias Action = RegisterAction
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
            
        case .onImageChange:
            if let image = state.image {
                return ImageProcessingClient.live.transformImage(image)
                    .map { .imageDataChanged(to: $0) }
            }
            return .none
            
        case .imageChanged(let image):
            state.image = image
            return .none
            
        case .imageDataChanged(let data):
            state.imageData = data
            return .none
            
        case .uploadImage(let name):
            FirebaseClient.uploadImage(data: state.imageData, name: name)
            return .none
            
        case .emailChanged(let email):
            state.email = email
            return Effect(value: .isFilled)
            
        case .passwordChanged(let password):
            state.password = password
            return Effect(value: .isFilled)
            
        case .nameChanged(let name):
            state.name = name
            return Effect(value: .isFilled)
            
        case .skillsChanged(let skills):
            state.skills = skills
            return Effect(value: .isFilled)
            
        case .isFilled:
            if !state.email.isEmpty,
               !state.password.isEmpty,
               !state.name.isEmpty,
               !state.skills.isEmpty {
                state.isFilled = true
            } else {
                state.isFilled = false
            }
            
            return .none
            
        case .updateError(let error):
            state.error = error
            return .none
            
        case .logIn(let user):
            state.user = user
            return Effect(value: .uploadInfo)
                .merge(with: Effect(value: .uploadImage(name: user.uid)))
            
        case .uploadInfo:
            if let user = state.user {
                state.userWithData = UserWithData(uid: user.uid,
                                                  email: state.email,
                                                  name: state.name,
                                                  skills: state.skills.components(separatedBy: ","))
                FirebaseClient.uploadUserWithData(from: state.userWithData)
            }
            return .none
            
        case .navigateBack:
            return .none
        }
    }
    
}
