import Foundation
import ComposableArchitecture

@Reducer
struct NewTransferDomain {
    
    @ObservableState
    struct State: Equatable {
        var preloadedAccountId = ""
        var amount = ""
        var error: NSError?
        var showConfirmation = false
        var transferComplete = false
        
        var sourceAccountPicker = AccountPickerDomain.State()
        var destinationAccountPicker = AccountPickerDomain.State()
    }
    
    enum Action: Sendable {
        // MARK: Child
        case sourceAccount(AccountPickerDomain.Action)
        case destinationAccount(AccountPickerDomain.Action)
        
        // MARK: Data
        case loadAccounts
        case didUpdateAmount(String)
        case accountsResponse([AccountItem])
        
        // MARK: UI
        case didTapCreate
        case didConfirm(Bool)
        case didDismissError
        
        // MARK: Automated
        case newTransferResponse(TransferItem)
        case didReceiveError(Error)
    }
    
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        Scope(state: \.sourceAccountPicker, action: \.sourceAccount) {
                    AccountPickerDomain()
                }
        Scope(state: \.destinationAccountPicker, action: \.destinationAccount) {
                    AccountPickerDomain()
                }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .sourceAccount, .destinationAccount:
                // Handled by AccountPickerDomain
                return .none
                
            case .loadAccounts:
                return .run { send in
                    let accounts = try await databaseClient.fetchAccounts()
                    await send(.accountsResponse(accounts))
                } catch: { error, send in
                    await send(.didReceiveError(error))
                }
                
            case .accountsResponse(let accounts):
                state.sourceAccountPicker.accounts = accounts
                state.destinationAccountPicker.accounts = accounts
                
                if state.sourceAccountPicker.selectedAccount == nil {
                        let sourceAccount = accounts.first(
                            where: { $0.id == state.preloadedAccountId }
                        ) ?? accounts.first
                        
                        state.sourceAccountPicker.selectedAccount = sourceAccount
                    }
                if state.destinationAccountPicker.selectedAccount == nil {
                    let destinationAccount = accounts.first(
                        where: { $0.id != state.preloadedAccountId }
                    ) ?? accounts.last
                    state.destinationAccountPicker.selectedAccount = destinationAccount
                }
                
                return .none
                
                // MARK: Data
            case .didUpdateAmount(let newValue):
                state.amount = newValue
                return .none
                
                // MARK: UI
            case .didTapCreate:
                let amount = Double(state.amount) ?? 0.0
                
                guard let account = state.sourceAccountPicker.selectedAccount else {
                    return .send(.didReceiveError(NSError(domain: "New Transfer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Please, select source account first"])))
                }
                
                guard amount > 0 else {
                    return .send(.didReceiveError(NSError(domain: "New Transfer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Amount must be higher than 0"])))
                }
                
                guard amount <= account.balance else {
                    return .send(.didReceiveError(NSError(domain: "New Transfer", code: 1, userInfo: [                    NSLocalizedDescriptionKey: "Insuficient funds. Your current balance is: \(account.balance)"])))
                }
                
                guard state.destinationAccountPicker.selectedAccount != state.sourceAccountPicker.selectedAccount
                else {
                    return .send(.didReceiveError(NSError(
                        domain: "New Transfer",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Credit account (\(state.destinationAccountPicker.selectedAccount?.id ?? "")) cannot be the same as the orderer account (\(state.sourceAccountPicker.selectedAccount?.id ?? ""))."
                        ]
                    )))
                }
                
                state.showConfirmation.toggle()
                
                return .none
                
            case .didConfirm(let possitive):
                if !possitive { return .none }
                
                let newTransferItem = NewTransferItem(
                    sourceAccountId: state.sourceAccountPicker.selectedAccount?.id ?? "",
                    amount: Double(state.amount) ?? 0.0,
                    destinationAccountId: state.destinationAccountPicker.selectedAccount?.id ?? ""
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
