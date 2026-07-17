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
    
    static func previewable() -> TransferModel {
        TransferModel(
            id: UUID(),
            sourceAccount: Persistence.initialData.first!,
            amount: 1000,
            destinationAccount: Persistence.initialData.last!,
            timestamp: .now,
            previousSourceBalance: 1200,
            previousDestinationBalance: 0
        )
    }
    
    static func previewable2() -> TransferModel {
        TransferModel(
            id: UUID(),
            sourceAccount: Persistence.initialData.last!,
            amount: 1000,
            destinationAccount: Persistence.initialData.first!,
            timestamp: .now,
            previousSourceBalance: 1500,
            previousDestinationBalance: 200,
        )
    }
}
