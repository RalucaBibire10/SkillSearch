import SwiftUI
import ComposableArchitecture

struct MyProfileReducer: ReducerProtocol {
    typealias State = MyProfileState
    typealias Action = MyProfileAction
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
            
        case .none:
            return .none
        
        case .nameChanged(let name):
            state.name = name
            state.currentUserData?.name = name
            return .none
            
        case .skillsChanged(let skills):
            state.skills = skills
            state.currentUserData?.skills = skills.components(separatedBy: ",")
            return .none
            
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
            FirebaseClient.uploadImage(data: state.imageData, name: state.currentUserData?.uid)
            return .none
            
        case .save:
            return .none
            
        case .logOut:
            return .none
            
        case .navigateBack:
            return .none
        }
    }
}
