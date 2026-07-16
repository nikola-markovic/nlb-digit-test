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
    
    init(id: UUID, sourceAccount: AccountModel? = nil, amount: Double, destinationAccount: AccountModel? = nil, timestamp: Date, previousSourceBalance: Double) {
        self.id = id
        self.sourceAccount = sourceAccount
        self.amount = amount
        self.destinationAccount = destinationAccount
        self.timestamp = timestamp
        self.previousSourceBalance = previousSourceBalance
    }
    
    static func previewable() -> TransferModel {
        TransferModel(
            id: UUID(),
            sourceAccount: nil,
            amount: 1000,
            destinationAccount: nil,
            timestamp: .now,
            previousSourceBalance: 1200
        )
    }
    
    static func previewable2() -> TransferModel {
        TransferModel(
            id: UUID(),
            sourceAccount: nil,
            amount: -1000,
            destinationAccount: nil,
            timestamp: .now,
            previousSourceBalance: 1200
        )
    }
}
