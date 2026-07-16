import Foundation
import SwiftData

@Model
final class AccountModel {
    @Attribute(.unique) var id: String
    
    var balance: Double
    var currency: String
    @Relationship(inverse: \TransactionModel.account)
    var transactions: [TransactionModel]
    var cards: [CardModel]
    
    var user: UserModel?
    
    init(id: String, balance: Double, currency: String, transactions: [TransactionModel], cards: [CardModel], user: UserModel?) {
        self.id = id
        self.balance = balance
        self.currency = currency
        self.transactions = transactions
        self.cards = cards
        self.user = user
    }
}
