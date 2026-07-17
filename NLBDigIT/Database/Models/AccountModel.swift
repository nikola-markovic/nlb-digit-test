import Foundation
import SwiftData

@Model
final class AccountModel: Hashable {
    @Attribute(.unique) var id: String
    
    var balance: Double
    
    init(id: String, balance: Double) {
        self.id = id
        self.balance = balance
    }
}
