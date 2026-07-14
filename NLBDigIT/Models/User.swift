import Foundation
import SwiftData

@Model
final class User {
    var id: Int
    var email: String
    var name: String
    var surname: String
    var accounts: [Account]
    
    init(id: Int, email: String, name: String, surname: String, accounts: [Account]) {
        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
        self.accounts = accounts
    }
}
