import Foundation

extension NewTransferDomain.State {
    static var mock: Self {
        Self(
            amount: "",
            sourceAccountPicker: .mock,
            destinationAccountPicker: .mock2
        )
    }
}
