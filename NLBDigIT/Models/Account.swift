import Foundation
import SwiftData

@Model
final class Account {
    var id: Int
    var balance: Double
    var currency: String
    var transactions: [Transaction]
    var cards: [Card]
    
    init(id: Int, balance: Double, currency: String, transactions: [Transaction], cards: [Card]) {
        self.id = id
        self.balance = balance
        self.currency = currency
        self.transactions = transactions
        self.cards = cards
    }
}
