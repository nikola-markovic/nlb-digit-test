import SwiftUI
import ComposableArchitecture
import LocalAuthentication
import SwiftData
import SwiftfulRouting

struct NewTransferView: View {
    @Bindable var store: StoreOf<NewTransferDomain>
    @Environment(\.modelContext) private var modelContext
    @Environment(\.router) private var router
    
    @Query private var storedAccounts: [AccountModel]
    
    var body: some View {
        Form {
            Section("From") {
                AccountPicker(
                    accounts: storedAccounts,
                    selection: $store
                        .selectedSourceAccount
                        .sending(\.didUpdateSourceAccount)
                )
            }
            
            Section("Transfer") {
                TextField(
                    "Amount",
                    text: $store.amount.sending(\.didUpdateAmount)
                )
                .keyboardType(.decimalPad)
                .font(.largeTitle.weight(.medium))
            }
            
            Section("To") {
                AccountPicker(
                    accounts: storedAccounts,
                    selection: $store
                        .selectedDestinationAccount
                        .sending(\.didUpdateDestinationAccount)
                )
            }
            
            Section("Proceed") {
                Button {
                    store.send(.didTapCreate)
                } label: {
                    Text("Transfer funds")
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .task { // Load initial accounts
            store.send(.didUpdateSourceAccount(storedAccounts.first))
            store.send(.didUpdateDestinationAccount(storedAccounts.last))
        }
        // Show error when received
        .onChange(of: store.error) { oldValue, newValue in
            showError(store.error)
            
        }
        // Fields are validated, ask user for confirmation
        .onChange(of: store.showConfirmation, { oldValue, newValue in
            proceed()
            
        })
        // User confirmed transfer
        .onChange(of: store.transferComplete, { oldValue, newValue in
            showSuccess()
            
        })
        .navigationTitle("New Transfer")
    }
    
    private func showError(_ error: Error?) {
        guard let error else { return }
        router.showAlert(AnyAlert(title: "Transfer error", subtitle: error.localizedDescription, buttons: {
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
            localizedReason: "Confirm banking transfer"
        ) { success, authenticationError in
            DispatchQueue.main.async {
                if let error = authenticationError {
                    store.send(.didReceiveError(error))
                } else {
                    submitTransfer()
                }
            }
        }
    }
    
    private func submitTransfer() {
        store.send(.didConfirm(true))
    }
    
    private func showSuccess() {
        router.showAlert(AnyAlert(title: "Transfer complete!", buttons: {
            Button {
                router.dismissAlert()
                router.dismissScreen()
            } label: {
                Text("OK")
            }
        }))
    }
}

#Preview {
    NewTransferView(
        store: Store(initialState: NewTransferDomain.State()) {
            NewTransferDomain()
        }
    )
}
