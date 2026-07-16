//
//  AccountPicker.swift
//  NLBDigIT
//
//  Created by Nikola on 7/16/26.
//

import SwiftUI

struct AccountPicker: View {
    let accounts: [AccountModel]
    @Binding var selection: AccountModel?
    
    var body: some View {
        Picker("Source account",
               selection: $selection
        ) {
            ForEach(accounts) { account in
                Text(account.id)
                    .tag(account as AccountModel?)
            }
        }
        Text(
            String(format: "Balance: %.2f %@", (selection?.balance ?? 0.0), selection?.currency ?? "")
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
