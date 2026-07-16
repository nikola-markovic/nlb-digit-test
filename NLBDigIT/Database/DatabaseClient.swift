import Foundation
import SwiftData
import ComposableArchitecture

@DependencyClient
struct DatabaseClient {
    var createTransaction: @Sendable (TransactionItem) async throws -> TransactionModel
    var getAccountWith: @Sendable (_ id: String) async throws -> AccountModel?
}

extension DatabaseClient: DependencyKey {
    static let liveValue = Self(
        createTransaction: { transactionItem in
            return try await createTransactionFrom(transactionItem: transactionItem)
        },
        
        getAccountWith: { id in
            return try await getAccountWith(id: id)
        }
    )
    
    static func createTransactionFrom(transactionItem: TransactionItem) async throws -> TransactionModel {
        let context = Persistence.sharedModelContainer.mainContext
        
        guard let ordererAccount = try await getAccountWith(id: transactionItem.ordererAccount)
        else {
            throw NSError(
                domain: "New Transaction", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(transactionItem.ordererAccount) Account not found"
                ]
            )
        }
        
        guard transactionItem.amount <= ordererAccount.balance else {
            throw NSError(
                domain: "New Transaction", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "Insuficient funds. Your current balance is: \(ordererAccount.balance)"
                ]
            )
        }
        
        guard let creditorAccount = try await getAccountWith(id: transactionItem.creditAccount)
        else {
            throw NSError(
                domain: "New Transaction", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(transactionItem.creditAccount) Account not found"
                ]
            )
        }
        
        ordererAccount.balance -= transactionItem.amount
        creditorAccount.balance += transactionItem.amount
        
        let model = TransactionModel.from(transactionItem)
        context.insert(model)
        
        try context.save()
        return model
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

extension TransactionModel {
    static func from(_ item: TransactionItem) -> TransactionModel {
        TransactionModel(
            id: UUID(),
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
            timestamp: .now,
            cardId: item.cardId,
            account: nil
        )
#warning("TODO: Don't forget the account")
    }
}
