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
    
    var preloadedAccountId: String?
    
    var body: some View {
        Form {
            Section("From") {
                AccountPickerView(
                    store: store.scope(
                        state: \.sourceAccountPicker,
                        action: \.sourceAccount
                    )
                )            }
            
            Section("Transfer") {
                TextField(
                    "Amount",
                    text: $store.amount.sending(\.didUpdateAmount)
                )
                .keyboardType(.decimalPad)
                .font(.largeTitle.weight(.medium))
            }
            
            Section("To") {
                AccountPickerView(
                    store: store.scope(
                        state: \.destinationAccountPicker,
                        action: \.destinationAccount
                    )
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
            loadInitialAccounts()
            
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
    
    private func loadInitialAccounts() {
        store.send(.loadAccounts)        
    }
    
    private func showError(_ error: Error?) {
        guard let error else { return }
        router.showAlert(.alert, title: "Transfer error", subtitle: error.localizedDescription, buttons: {
            Button {
                store.send(.didDismissError)
            } label: {
                Text("OK")
            }
        })
    }
    
    
    // MARK: Biometrics
    
    var areYouSureText: String {
        """
        \(store.amount) \(Locale.current.currencySymbol ?? "") will be transferred
        from \(store.sourceAccountPicker.selectedAccount?.id ?? "") 
        to \(store.sourceAccountPicker.selectedAccount?.id ?? "").
        
        Proceed?
        """
    }
    
    private func proceed() {
        router.showAlert(
            .alert,
            title: "Are you sure?",
            subtitle: areYouSureText,
            buttons: {
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
            }
        )
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            additionalConfirmation()
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
    
    private func additionalConfirmation() {
        router.showAlert(
            .alert,
            title: "FaceID not set. Please confirm again.",
            subtitle: areYouSureText,
            buttons: {
                Button {
                    submitTransfer()
                } label: {
                    Text("YES")
                }
                
                Button {
                    
                } label: {
                    Text("NO")
                }
            })
    }
    
    private func submitTransfer() {
        store.send(.didConfirm(true))
    }
    
    private func showSuccess() {
        router.showAlert(.alert, title: "Transfer complete!", buttons: {
            Button {
                router.dismissAlert()
                router.dismissScreen()
            } label: {
                Text("OK")
            }
        })
    }
}

#Preview {
    let mock = Store(initialState: .mock) {
        NewTransferDomain()
    }
    RouterView {_ in
        NewTransferView(
            store: mock
        )
    }
}
