import Foundation
import SwiftData
import ComposableArchitecture

@DependencyClient
struct DatabaseClient {
    var createTransaction: @Sendable (TransactionItem) throws -> Void
}

extension DatabaseClient: DependencyKey {
    static let liveValue = Self(
        createTransaction: { transactionItem in
            let context = ModelContext(Persistence.sharedModelContainer)
            let model = TransactionModel.from(transactionItem)
            context.insert(model)
            try context.save()
        }
    )
}

extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}

extension TransactionModel {
    static func from(_ item: TransactionItem) -> TransactionModel {
        TransactionModel(
            id: item.id,
            ordererName: item.ordererName,
            ordererAddress: item.ordererAddress,
            ordererPlace: item.ordererPlace,
            
            creditorName: item.creditorName,
            creditorAddress: item.creditorAddress,
            creditorPlace: item.creditorPlace,
            code: item.code,
            amount: item.amount,
            model: item.model,
            referenceNumber: item.referenceNumber,
            purpose: item.purpose,
            timestamp: item.timestamp,
            cardId: item.cardId,
            account: nil
        )
#warning("TODO: Don't forget the account")
    }
}
