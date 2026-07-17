import SwiftUI
import SwiftfulRouting
import ComposableArchitecture

struct TransferDetailsView: View {
    @Environment(\.router) private var router
    let transfer: TransferModel
    let selectedAccountId: String
    
    var isIncoming: Bool {
        selectedAccountId == transfer.destinationAccount?.id
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Text(formattedTextWithPrefix(from: transfer.amount))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(amountColor())
                    Spacer()
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("From")
                        .font(.footnote)
                    Text(transfer.sourceAccount?.id ?? "")
                    Image(systemName: "arrow.down")
                        .padding()
                    Text ("To")
                        .font(.footnote)
                    Text(transfer.destinationAccount?.id ?? "")
                }
                
                HStack {
                    Text("Timestamp:")
                    Spacer()
                    Text(transfer.timestamp.formatted(date: .complete, time: .standard))
                        .multilineTextAlignment(.trailing)
                }
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Previous balance:")
                        Spacer()
                        Text(formattedText(from: previousBalance))
                            .multilineTextAlignment(.trailing)
                    }
                    Text(formattedTextWithPrefix(from: transfer.amount))
                        .foregroundStyle(amountColor())
                }
                HStack {
                    Text("New balance:")
                    Spacer()
                    Text(formattedText(from: newBalance))
                        .multilineTextAlignment(.trailing)
                }
            } footer: {
                Button {
                    UIPasteboard.general.string = "\(transfer.id)"
                    router.showAlert(.alert, title: "ID Copied to clipboard.")
                } label: {
                    Text("id: \(transfer.id)")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Section {
                Button {
                    openRepeatTransfer()
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Repeat transfer")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .navigationTitle("Transfer details")
    }
    
    private func formattedTextWithPrefix(from value: Double) -> String {
        let p = isIncoming ? "+ " : "- "
        return "\(p)\(formattedText(from: value))"
    }
    
    private func formattedText(from value: Double) -> String {
        return NumberFormatter.localizedString(
            from: NSNumber(value: value),
            number: .currency
        )
    }
    
    private var previousBalance: Double {
        if isIncoming {
            return transfer.previousDestinationBalance
        } else {
            return transfer.previousSourceBalance
        }
    }
    
    private var newBalance: Double {
        if isIncoming {
            previousBalance + transfer.amount
        } else {
            previousBalance - transfer.amount
        }
    }
    
    private func amountColor() -> Color {
        if isIncoming {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    private func openRepeatTransfer() {
        let newTransferStore = Store(initialState: NewTransferDomain.State(
            selectedSourceAccount: transfer.sourceAccount,
            amount: "\(transfer.amount)",
            selectedDestinationAccount: transfer.destinationAccount,
            )) {
            NewTransferDomain()
        }
        router.showScreen(.push) { router in
            NewTransferView(store: newTransferStore)
        }
    }
}

#Preview {
    TransferDetailsView(transfer: .previewable(), selectedAccountId: TransferModel.previewable().destinationAccount!.id)
    TransferDetailsView(transfer: .previewable2(), selectedAccountId: "")
}
