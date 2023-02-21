import Foundation
import FirebaseDatabase

struct UserWithData: Equatable, Hashable {
    var uid: String
    var email: String
    var name: String
    var skills: [String]
    
    init(uid: String, email: String, name: String, skills: [String]) {
        self.uid = uid
        self.email = email
        self.name = name
        self.skills = skills
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        uid = snapshotValue[UserField.uid.rawValue] as! String
        email = snapshotValue[UserField.email.rawValue] as! String
        name = snapshotValue[UserField.name.rawValue] as! String
        skills = snapshotValue[UserField.skills.rawValue] as! [String]
    }
    
    func toAnyObject() -> Any {
        return [
            UserField.uid.rawValue: uid,
            UserField.email.rawValue: email,
            UserField.name.rawValue: name,
            UserField.skills.rawValue: skills
        ]
    }
}

enum UserField: String {
    case uid = "uid"
    case email = "email"
    case name = "name"
    case skills = "skills"
}
