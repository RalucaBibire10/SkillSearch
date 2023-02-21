import SwiftUI
import PhotosUI
import FirebaseAuth
import ComposableArchitecture

enum RegisterAction {
    case imageChanged(to: PhotosPickerItem?)
    case imageDataChanged(to: Data?)
    case uploadImage(name: String?)
    case onImageChange
    
    case uploadInfo
    
    case emailChanged(to: String)
    case passwordChanged(to: String)
    case nameChanged(to: String)
    case skillsChanged(to: String)
    
    case updateError(to: String)
    case logIn(User)
    
    case isFilled
    
    case navigateBack
}
