import Foundation
import ComposableArchitecture

@Reducer
struct NewTransferDomain {
    
    @ObservableState
    struct State: Equatable {
        var selectedSourceAccount: AccountModel?
        var amount = ""
        var selectedDestinationAccount: AccountModel?

        var error: NSError?
        var showConfirmation = false
        
        var transferComplete = false
    }
    
    enum Action: Sendable {
        // MARK: Data
        case didUpdateSourceAccount(AccountModel?)
        case didUpdateAmount(String)
        case didUpdateDestinationAccount(AccountModel?)
        
        // MARK: UI
        case didTapCreate
        case didConfirm(Bool)
        case didDismissError
        
        // MARK: Automated
        case newTransferResponse(TransferModel)
        case didReceiveError(Error)
    }
    
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: Data
            case .didUpdateSourceAccount(let newValue):
                state.selectedSourceAccount = newValue
                return .none
                
            case .didUpdateAmount(let newValue):
                state.amount = newValue
                return .none
                
            case .didUpdateDestinationAccount(let newValue):
                state.selectedDestinationAccount = newValue
                return .none
                
                // MARK: UI
            case .didTapCreate:
                let amount = Double(state.amount) ?? 0.0
                
                guard let account = state.selectedSourceAccount else {
                    return .send(.didReceiveError(NSError(domain: "New Transfer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Please, select source account first"])))
                }
                
                guard amount > 0 else {
                    return .send(.didReceiveError(NSError(domain: "New Transfer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Amount must be higher than 0"])))
                }
                
                guard amount <= account.balance else {
                    return .send(.didReceiveError(NSError(domain: "New Transfer", code: 1, userInfo: [                    NSLocalizedDescriptionKey: "Insuficient funds. Your current balance is: \(account.balance)"])))
                }
                
                guard state.selectedDestinationAccount != state.selectedSourceAccount
                else {
                    return .send(.didReceiveError(NSError(
                        domain: "New Transfer",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Credit account (\(state.selectedDestinationAccount?.id ?? "")) cannot be the same as the orderer account (\(state.selectedSourceAccount?.id ?? ""))."
                        ]
                    )))
                }
                
                state.showConfirmation.toggle()
                
                return .none
                
            case .didConfirm(let possitive):
                if !possitive { return .none }
                
                let newTransferItem = NewTransferItem(
                    sourceAccountId: state.selectedSourceAccount?.id ?? "",
                    amount: Double(state.amount) ?? 0.0,
                    destinationAccountId: state.selectedDestinationAccount?.id ?? ""
                )
                
                return .run(operation: { send in
                    let model = try await databaseClient.createTransfer(newTransferItem)
                    await send(.newTransferResponse(model))
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
            
            case .newTransferResponse(_):
                state.transferComplete.toggle()
                return .none
            }
        }
    }
}

private extension Error {
    func toNSError() -> NSError {
        NSError(domain: "New Transfer", code: 0, userInfo: [NSLocalizedDescriptionKey: self.localizedDescription])
    }
}
