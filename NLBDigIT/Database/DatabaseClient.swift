import Foundation
import SwiftData
import ComposableArchitecture

@DependencyClient
struct DatabaseClient {
    var createTransfer: @Sendable (NewTransferItem) async throws -> TransferModel
    var getAccountWith: @Sendable (_ id: String) async throws -> AccountModel?
}

extension DatabaseClient: DependencyKey {
    static let liveValue = Self(
        createTransfer: { transferItem in
            return try await createTransferFrom(transferItem: transferItem)
        },
        
        getAccountWith: { id in
            return try await getAccountWith(id: id)
        }
    )
    
    static func createTransferFrom(transferItem: NewTransferItem) async throws -> TransferModel {
        let context = Persistence.sharedModelContainer.mainContext
        
        guard let sourceAccount = try await getAccountWith(id: transferItem.sourceAccountId)
        else {
            throw NSError(
                domain: "New Transfer", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(transferItem.sourceAccountId) Account not found"
                ]
            )
        }
        
        guard transferItem.amount <= sourceAccount.balance else {
            throw NSError(
                domain: "New Transfer", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "Insuficient funds. Your current balance is: \(sourceAccount.balance)"
                ]
            )
        }
        
        guard let destinationAccount = try await getAccountWith(id: transferItem.destinationAccountId)
        else {
            throw NSError(
                domain: "New Transfer", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(transferItem.destinationAccountId) Account not found"
                ]
            )
        }
        
        let sourceModel = TransferModel(
            id: UUID(),
            sourceAccount: sourceAccount,
            amount: transferItem.amount,
            destinationAccount: destinationAccount,
            timestamp: .now,
            previousSourceBalance: sourceAccount.balance,
            previousDestinationBalance: destinationAccount.balance,
        )

        sourceAccount.balance -= transferItem.amount
        destinationAccount.balance += transferItem.amount
        
        context.insert(sourceModel)
        
        try context.save()
        return sourceModel
    }
    
    static func getAccountWith(id: String) async throws -> AccountModel? {
        let context = Persistence.sharedModelContainer.mainContext
        let predicate = #Predicate<AccountModel> { account in
            account.id == id
        }
        
        let descriptor = FetchDescriptor<AccountModel>(predicate: predicate)

        let account = try context.fetch(descriptor)
        return account.first
    }
}

extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
