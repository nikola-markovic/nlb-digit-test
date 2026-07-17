import SwiftUI
import _SwiftData_SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var accounts: [AccountModel]
    @State private var account: AccountModel?

    var body: some View {
        VStack {
            Text("For account:")
            AccountPicker(accounts: accounts, selection: $account)
                .font(Font.system(.largeTitle, weight: .bold))
            
            TransfersView(accountId: account?.id ?? "")
        }
        .task {
            if account == nil {
                account = accounts.first
            }
        }
    }
}

#Preview {
    HomeView()
}
