import Foundation
import SwiftData
import ComposableArchitecture

@DependencyClient
struct DatabaseClient {
    var createTransfer: @Sendable (NewTransferItem) async throws -> TransferItem
    var getAccountWith: @Sendable (_ id: String) async throws -> AccountModel?

    var fetchAccounts: @Sendable () async throws -> [AccountItem]
}

extension DatabaseClient: DependencyKey {
    static let liveValue = Self(
        createTransfer: { newTransferItem in
            return try await createTransferFrom(newTransferItem: newTransferItem)
        },
        
        getAccountWith: { id in
            return try await getAccountWith(id: id)
        },
        
        fetchAccounts: {
            return try await fetchAccounts()
        }
    )
    
    static func createTransferFrom(newTransferItem: NewTransferItem) async throws -> TransferItem {
        let context = Persistence.sharedModelContainer.mainContext
        
        guard let sourceAccount = try await getAccountWith(id: newTransferItem.sourceAccountId)
        else {
            throw NSError(
                domain: "New Transfer", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(newTransferItem.sourceAccountId) Account not found"
                ]
            )
        }
        
        guard newTransferItem.amount <= sourceAccount.balance else {
            throw NSError(
                domain: "New Transfer", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "Insuficient funds. Your current balance is: \(sourceAccount.balance)"
                ]
            )
        }
        
        guard let destinationAccount = try await getAccountWith(id: newTransferItem.destinationAccountId)
        else {
            throw NSError(
                domain: "New Transfer", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(newTransferItem.destinationAccountId) Account not found"
                ]
            )
        }
        
        let sourceModel = TransferModel(
            id: UUID(),
            sourceAccount: sourceAccount,
            amount: newTransferItem.amount,
            destinationAccount: destinationAccount,
            timestamp: .now,
            previousSourceBalance: sourceAccount.balance,
            previousDestinationBalance: destinationAccount.balance,
        )

        sourceAccount.balance -= newTransferItem.amount
        destinationAccount.balance += newTransferItem.amount
        
        context.insert(sourceModel)
        
        try context.save()
        return TransferItem.from(sourceModel)
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
    
    static func fetchAccounts() async throws -> [AccountItem] {
        let context = Persistence.sharedModelContainer.mainContext
        
        let descriptor = FetchDescriptor<AccountModel>()
        let accounts = try context.fetch(descriptor)
        
        return accounts.compactMap({ AccountItem.from($0) })
    }
}

extension TransferItem {
    static func from(_ model: TransferModel) -> TransferItem {
        TransferItem(
            id: model.id,
            sourceAccount: AccountItem.from(model.sourceAccount),
            amount: model.amount,
            destinationAccount: AccountItem.from(model.destinationAccount),
            timestamp: model.timestamp,
            previousSourceBalance: model.previousSourceBalance,
            previousDestinationBalance: model.previousDestinationBalance
        )
    }
}

extension AccountItem {
    static func from(_ model: AccountModel?) -> AccountItem? {
        guard let model else { return nil }
        return AccountItem(id: model.id, balance: model.balance)
    }
}

extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
