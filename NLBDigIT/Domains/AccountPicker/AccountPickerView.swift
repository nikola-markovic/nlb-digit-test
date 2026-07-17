import SwiftUI
import ComposableArchitecture

struct AccountPickerView: View {
    @Bindable var store: StoreOf<AccountPickerDomain>
    
    var body: some View {
        Picker("Account",
               selection: $store.selectedAccount.sending(\.didUpdateSelection)
        ) {
            ForEach(store.accounts) { account in
                Text(account.id)
                    .tag(account as AccountItem)
            }
        }
        Text(balanceText())
    }
    
    private func balanceText() -> String {
        return NumberFormatter.localizedString(
            from: NSNumber(value: store.selectedAccount?.balance ?? 0.0),
            number: .currency
        )
    }
}

#Preview {
    AccountPickerView(store: Store(initialState: .mock) {
        AccountPickerDomain()
    })
}
