import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ComposableArchitecture

struct FirebaseClient {
    
    // MARK: - Properties
    
    static let auth = Auth.auth()
    static let storageRef = Storage.storage().reference()
    static let databaseRef = Database.database().reference()
    static var userChildRef: DatabaseReference {
        databaseRef.child("users")
    }
    
    static var currentUser: User? {
        auth.currentUser
    }
    
    // MARK: - Functions
    
    static func logOut() {
        try? auth.signOut()
    }
    
    static func uploadImage(data: Data?, name: String?) {
        if let name = name,
           let data = data {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let profilePictureRef = storageRef.child("\(name).jpg")
            let _ = profilePictureRef.putData(data) { metadata, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                guard let _ = metadata else {
                    return
                }
            }
        }
    }
    
    static func uploadUserWithData(from user: UserWithData?) {
        if let user = user {
            userChildRef
                .child(user.uid)
                .setValue(user.toAnyObject())
        }
    }
    
    // MARK: - App Reducer
    
    static func fetchCurrentUser(using viewStore: ViewStoreOf<AppReducer>) {
        if let user = currentUser {
            databaseRef.child("users/\(user.uid)").getData { error, snapshot in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let snapshot = snapshot {
                        let user = UserWithData(snapshot: snapshot)
                        viewStore.send(.fetchCurrentUser(user: user))
                    }
                }
            }
        }
    }
    
    static func fetchProfilePicture(using viewStore: ViewStoreOf<AppReducer>) {
        if !viewStore.isUserSet {
            if let user = viewStore.user {
                let profilePictureRef = storageRef.child("\(user.uid).jpg")
                profilePictureRef.getData(maxSize: 1 * 4096 * 4096) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        viewStore.send(.updateProfilePicture(data: data))
                    }
                }
            }
        }
    }
    
    // MARK: - Home Reducer
    
    static func fetchUsers(using viewStore: ViewStoreOf<HomeReducer>) {
        userChildRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                if let children = snapshot?.children {
                    for child in children {
                        let user = UserWithData(snapshot: child as! DataSnapshot)
                        viewStore.send(.fetchUser(user: user))
                        fetchUserImage(using: viewStore, uid: user.uid)
                    }
                }
            }
        }
    }
    
    static func fetchUserImage(using viewStore: ViewStoreOf<HomeReducer>, uid: String) {
        let profilePictureRef = storageRef.child("\(uid).jpg")
        profilePictureRef.getData(maxSize: 1 * 4096 * 4096) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                viewStore.send(.updateUserPicture(user: uid, data: data))
            }
        }
    }
    
    // MARK: - Reset Password Reducer
    
    static func sendResetPasswordEmail(using viewStore: ViewStoreOf<ResetPasswordReducer>) {
        auth.sendPasswordReset(withEmail: viewStore.email) { error in
            if error != nil {
                viewStore.send(.updateMessage(message: error?.localizedDescription ?? Localization.unknownError, isError: true))
            } else {
                viewStore.send(.updateMessage(message: Localization.confirmation, isError: false))
            }
        }
    }
    
    // MARK: - Register Reducer
    
    static func createUser(using viewStore: ViewStoreOf<RegisterReducer>) {
        auth.createUser(withEmail: viewStore.email, password: viewStore.password) { result, error in
            if error != nil {
                viewStore.send(.updateError(to: error?.localizedDescription ?? Localization.unknownError))
            } else {
                if let user = result?.user {
                    viewStore.send(.logIn(user))
                }
            }
        }
    }
    
    // MARK: - Login Reducer
    
    static func createUser(using viewStore: ViewStoreOf<LoginReducer>) {
        auth.signIn(withEmail: viewStore.email,
                    password: viewStore.password) { result, error in
            if error != nil {
                viewStore.send(.updateError(to: error?.localizedDescription ?? Localization.unknownError))
            } else {
                if let user = result?.user {
                    viewStore.send(.logIn(user))
                    let ref = Database.database().reference()
                    ref.child("users/\(user.uid)").getData { error, snapshot in
                        guard error == nil else {
                            print(error?.localizedDescription ?? Localization.unknownError)
                            return
                        }
                        if let snapshot = snapshot {
                            viewStore.send(.updateUserData(from: snapshot))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - My Profile Reducer
    static func updateUser(using viewStore: ViewStoreOf<MyProfileReducer>) {
        if let uid = viewStore.currentUserData?.uid {
            let updates = [
                UserField.name.rawValue: viewStore.name,
                UserField.skills.rawValue: viewStore.skills.components(separatedBy: ",")
            ] as [String : Any]
            userChildRef.child(uid).updateChildValues(updates) { error, _ in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    viewStore.send(.save)
                }
            }
        }
    }
}
