import Foundation
import ComposableArchitecture

@Reducer
struct AccountPickerDomain {
    
    @ObservableState
    struct State: Equatable {
        var selectedAccount: AccountItem?
        var accounts: [AccountItem] = []
    }
    
    enum Action: Sendable {
        case didUpdateSelection(AccountItem?)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didUpdateSelection(let newValue):
                state.selectedAccount = newValue
                return .none
            }
        }
    }
}
