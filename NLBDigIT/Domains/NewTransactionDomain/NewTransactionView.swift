import SwiftUI
import ComposableArchitecture
import LocalAuthentication
import SwiftData
import SwiftfulRouting

struct NewTransactionView: View {
    @Bindable var store: StoreOf<NewTransactionDomain>
    @Environment(\.modelContext) private var modelContext
    @Environment(\.router) private var router
    
    @Query private var storedAccounts: [AccountModel]
    @State private var amount: String = ""
    
    var body: some View {
        Form {
            
            // MARK: Account
            
            Section("From") {
                Picker("Source account", selection: $store.selectedSourceAccount.sending(\.didUpdateSourceAccount)) {
                    ForEach(storedAccounts) { account in
                        Text(account.id)
                            .tag(account as AccountModel?)
                    }
                }
                Text(String(format: "Balance: %.2f", store.selectedSourceAccount?.balance ?? 0.0))
            }
            
            Section("Transfer") {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            // MARK: Payment
            
            Section("To") {
                
                Picker("Destination account", selection: $store.selectedDestinationAccount.sending(\.didUpdateDestinationAccount)) {
                    ForEach(storedAccounts) { account in
                        Text(account.id)
                            .tag(account as AccountModel?)
                    }
                }
                Text(String(format: "Balance: %.2f", store.selectedDestinationAccount?.balance ?? 0.0))
            }
            
            Section {
                Button {
                    store.send(.didTapCreate)
                } label: {
                    Text("Transfer funds")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .task {
            store.send(.didUpdateSourceAccount(storedAccounts.first))
            store.send(.didUpdateDestinationAccount(storedAccounts.last))
        }
        .onChange(of: amount) { oldValue, newValue in
            let doubleValue = Double(amount) ?? 0.0
            store.send(.didUpdateAmount(doubleValue))
        }
        .onChange(of: store.transferComplete, { oldValue, newValue in
            router.showAlert(AnyAlert(title: "Transaction complete!", buttons: {
                Button {
                    router.dismissAlert()
                    router.dismissScreen()
                } label: {
                    Text("OK")
                }
            }))
        })
        .onChange(of: store.error) { oldValue, newValue in
            showError(store.error)
        }
        .onChange(of: store.showConfirmation, { oldValue, newValue in
            proceed()
        })
        .navigationTitle("New Transaction")
    }
    
    private func showError(_ error: Error?) {
        guard let error else { return }
        router.showAlert(AnyAlert(title: "Transaction error", subtitle: error.localizedDescription, buttons: {
            Button {
                store.send(.didDismissError)
            } label: {
                Text("OK")
            }
        }))
    }
    
    
    // MARK: Biometrics
    
    private func proceed() {
        router.showAlert(AnyAlert(title: "Are you sure?", buttons: {
            Button {
                authenticate()
            } label: {
                Text("YES")
            }
            Button {
                store.send(.didConfirm(false))
            } label: {
                Text("NO")
            }
        }))
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            store.send(.didReceiveError(error ?? NSError()))
            return
        }
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Confirm banking transaction"
        ) { success, authenticationError in
            
            DispatchQueue.main.async {
                if let error = authenticationError {
                    store.send(.didReceiveError(error))
                } else {
                    submitTransaction()
                }
            }
        }
    }
    
    private func submitTransaction() {
        store.send(.didConfirm(true))
    }
}

#Preview {
    NewTransactionView(
        store: Store(initialState: NewTransactionDomain.State()) {
            NewTransactionDomain()
        }
    )
}
