import Foundation
import ComposableArchitecture

@Reducer
struct NewTransactionDomain {
    
    @ObservableState
    struct State: Equatable {
        var transactionItem = TransactionItem.initialTransaction()
        var error: NSError?
        var isShowingError = false
        var selectedSourceAccount: AccountModel?
        var selectedDestinationAccount: AccountModel?
        var showConfirmation = false
        
        var transferComplete = false
    }
    
    enum Action: Sendable {
        // MARK: Data
        case didUpdateSourceAccount(AccountModel?)
        case didUpdateAmount(Double)
        case didUpdateDestinationAccount(AccountModel?)
        
        // MARK: UI
        case didTapCreate
        case didConfirm(Bool)
        case didDismissError
        
        // MARK: Automated
        case newTransactionResponse(TransactionModel)
        case didReceiveError(Error)
    }
    
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: Data
            case .didUpdateSourceAccount(let newValue):
                state.transactionItem.ordererAccount = newValue?.id ?? ""
                state.selectedSourceAccount = newValue
                return .none
                
            case .didUpdateAmount(let newValue):
                state.transactionItem.amount = newValue
                return .none
                
            case .didUpdateDestinationAccount(let newValue):
                state.transactionItem.creditAccount = newValue?.id ?? ""
                state.selectedDestinationAccount = newValue
                return .none
                
                // MARK: UI
            case .didTapCreate:
                guard let account = state.selectedSourceAccount else {
                    return .send(.didReceiveError(NSError(domain: "New Transaction", code: 1, userInfo: [NSLocalizedDescriptionKey: "Please, select source account first"])))
                }
                
                guard state.transactionItem.amount > 0 else {
                    return .send(.didReceiveError(NSError(domain: "New Transaction", code: 1, userInfo: [NSLocalizedDescriptionKey: "Amount must be higher than 0"])))
                }
                
                guard state.transactionItem.amount <= account.balance else {
                    return .send(.didReceiveError(NSError(domain: "New Transaction", code: 1, userInfo: [                    NSLocalizedDescriptionKey: "Insuficient funds. Your current balance is: \(account.balance)"])))
                }
                
                guard state.transactionItem.creditAccount != state.transactionItem.ordererAccount
                else {
                    return .send(.didReceiveError(NSError(
                        domain: "New Transaction",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Credit account (\(state.transactionItem.creditAccount)) cannot be the same as the orderer account (\(state.transactionItem.ordererAccount))."
                        ]
                    )))
                }
                
                state.showConfirmation.toggle()
                
                return .none
                
            case .didConfirm(let possitive):
                if !possitive { return .none }
                
                let transactionItem = state.transactionItem
                
                return .run(operation: { send in
                    let model = try await databaseClient.createTransaction(transactionItem)
                    await send(.newTransactionResponse(model))
                    print("saved \(model)")
                    
                }, catch: { error, send in
                    DispatchQueue.main.async {
                        send(.didReceiveError(error))
                    }
                })
            case .didDismissError:
                state.error = nil
                return .none
                
                // MARK: Automated
            case .didReceiveError(let error):
                state.error = error.toNSError()
                return .none
            
            case .newTransactionResponse(let _):
                state.transferComplete.toggle()
                return .none
            }
        }
    }
}

private extension Error {
    func toNSError() -> NSError {
        NSError(domain: "New Transaction", code: 0, userInfo: [NSLocalizedDescriptionKey: self.localizedDescription])
    }
}
