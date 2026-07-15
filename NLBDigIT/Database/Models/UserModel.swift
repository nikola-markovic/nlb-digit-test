import Foundation
import SwiftData

@Model
final class UserModel {
    var id: UUID
    
    var email: String
    var name: String
    var surname: String
    @Relationship(inverse: \AccountModel.user)
    var accounts: [AccountModel]
    
    init(id: UUID, email: String, name: String, surname: String, accounts: [AccountModel]) {
        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
        self.accounts = accounts
    }
}
