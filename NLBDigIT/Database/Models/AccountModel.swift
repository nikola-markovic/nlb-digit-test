import Foundation
import SwiftData

@Model
final class AccountModel {
    @Attribute(.unique) var id: String
    
    var balance: Double
    var currency: String
    @Relationship(inverse: \TransferModel.sourceAccount)
    @Relationship(inverse: \TransferModel.destinationAccount)
    var transfers: [TransferModel]
    
    init(id: String, balance: Double, currency: String, transfers: [TransferModel]) {
        self.id = id
        self.balance = balance
        self.currency = currency
        self.transfers = transfers
    }
}
