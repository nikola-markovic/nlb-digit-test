import SwiftUI

struct TransferCellView: View {
    let transfer: TransferModel
    
    var body: some View {
        HStack {
            Text(amountFormatted())
                .foregroundStyle(amountColor())
            Spacer()
            Text(formatterDate())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private func amountFormatted() -> String {
        return NumberFormatter.localizedString(
            from: NSNumber(value: transfer.amount),
            number: .currency
        )
        
    }
    
    private func amountColor() -> Color {
        if transfer.amount > 0 {
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
        transfer: transfer
    )
        
    TransferCellView(
        transfer: transfer2
    )

}
