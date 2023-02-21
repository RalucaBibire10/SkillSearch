import SwiftUI
import PhotosUI

enum MyProfileAction {
    case none
    
    case nameChanged(to: String)
    case skillsChanged(to: String)
    case onImageChange
    case imageChanged(to: PhotosPickerItem?)
    case imageDataChanged(to: Data?)
    
    case save
    case logOut
    
    case navigateBack
}
