import SwiftUI

struct TransferCellView: View {
    let transfer: TransferModel
    let selectedAccountId: String

    var isIncoming: Bool {
        selectedAccountId == transfer.destinationAccount?.id
    }
    
    var body: some View {
        HStack {
            Text(formattedText(from: transfer.amount))
                .foregroundStyle(amountColor())
            Spacer()
            Text(formatterDate())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private func formattedText(from value: Double) -> String {
        let p = isIncoming ? "+ " : "- "
        let formatted = NumberFormatter.localizedString(
            from: NSNumber(value: value),
            number: .currency
        )
        return "\(p)\(formatted)"
    }

    private func amountColor() -> Color {
        if isIncoming {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    func formatterDate() -> String {
        if Calendar.current.isDateInToday(transfer.timestamp) {
            return transfer.timestamp.formatted(date: .omitted, time: .shortened)
        } else {
            return transfer.timestamp.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

#Preview {
    @Previewable let transfer = TransferModel.previewable()
    @Previewable let transfer2 = TransferModel.previewable2()
    
    TransferCellView(
        transfer: transfer,
        selectedAccountId: transfer.destinationAccount!.id
    )
        
    TransferCellView(
        transfer: transfer2,
        selectedAccountId: ""
    )

}
