import SwiftUI

struct AccountPicker: View {
    let accounts: [AccountModel]
    @Binding var selection: AccountModel?
    
    var body: some View {
        Picker("Account",
               selection: $selection
        ) {
            ForEach(accounts) { account in
                Text(account.id)
                    .tag(account as AccountModel?)
            }
        }
        Text(balanceText())
    }
    
    private func balanceText() -> String {
        return NumberFormatter.localizedString(
            from: NSNumber(value: selection?.balance ?? 0.0),
            number: .currency
        )
    }
}

#Preview {
    @Previewable let accounts = Persistence.initialData
    @Previewable @State var account: AccountModel?
    
    AccountPicker(
        accounts: accounts,
        selection: $account
    )
}
