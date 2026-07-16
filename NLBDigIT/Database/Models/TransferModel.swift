import Foundation
import SwiftData

@Model
final class TransferModel {
    @Attribute(.unique) var id: UUID
    
    var sourceAccount: AccountModel?
    var amount: Double
    var destinationAccount: AccountModel?
    var timestamp: Date
    var previousSourceBalance: Double
    var previousDestinationBalance: Double
    
    init(id: UUID, sourceAccount: AccountModel? = nil, amount: Double, destinationAccount: AccountModel? = nil, timestamp: Date, previousSourceBalance: Double, previousDestinationBalance: Double) {
        self.id = id
        self.sourceAccount = sourceAccount
        self.amount = amount
        self.destinationAccount = destinationAccount
        self.timestamp = timestamp
        self.previousSourceBalance = previousSourceBalance
        self.previousDestinationBalance = previousDestinationBalance
    }
}
