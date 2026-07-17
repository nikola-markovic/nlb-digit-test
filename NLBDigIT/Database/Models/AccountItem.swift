import Foundation
import SwiftData

struct AccountItem: Hashable, Equatable, Identifiable, Sendable {
    static func == (lhs: AccountItem, rhs: AccountItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    var balance: Double
    
    init(id: String, balance: Double) {
        self.id = id
        self.balance = balance
    }
}
