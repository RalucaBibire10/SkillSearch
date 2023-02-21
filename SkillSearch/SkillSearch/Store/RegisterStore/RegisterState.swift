import SwiftUI
import PhotosUI
import FirebaseAuth

struct RegisterState: Equatable {
    var isFilled = false
    
    var image: PhotosPickerItem? = nil
    var imageData: Data? = nil
    
    var email = String.empty
    var password = String.empty
    var name = String.empty
    var skills = String.empty
    
    var error = String.empty
    var user: User? = nil
    var userWithData: UserWithData?
}
