import SwiftUI
import PhotosUI
import FirebaseAuth

public struct MyProfileState: Equatable {
    var currentUserData: UserWithData?
    var image: PhotosPickerItem? = nil
    var imageData: Data?
    
    var name: String = .empty
    var skills: String = .empty
}
