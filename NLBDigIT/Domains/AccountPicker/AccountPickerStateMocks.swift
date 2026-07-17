import Foundation

extension AccountPickerDomain.State {
    static var mock: Self {
        Self(
            selectedAccount: Persistence.initialStructs.first!,
            accounts: Persistence.initialStructs
        )
    }
    static var mock2: Self {
        Self(
            selectedAccount: Persistence.initialStructs.last!,
            accounts: Persistence.initialStructs
        )
    }

}


