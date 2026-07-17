import Foundation

struct TransferItem: Hashable, Identifiable, Equatable {
    var id: UUID
    
    var sourceAccount: AccountItem?
    var amount: Double
    var destinationAccount: AccountItem?
    var timestamp: Date
    var previousSourceBalance: Double
    var previousDestinationBalance: Double
    
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
