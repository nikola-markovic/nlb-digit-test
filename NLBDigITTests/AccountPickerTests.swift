import Testing
import ComposableArchitecture
@testable import NLBDigIT

@MainActor
struct AccountPickerTests {

    @Test func testPickedAccount() async throws {
        let accounts = Persistence.initialStructs
        let store = TestStore(initialState: AccountPickerDomain.State(
            selectedAccount: accounts.first,
            accounts: accounts)) {
            AccountPickerDomain()
        }
        assert(store.state.accounts == accounts)
        assert(store.state.selectedAccount == accounts.first)
        
        let account = accounts.last
        await store.send(.didUpdateSelection(account)) {
            $0.selectedAccount = account
        }
    }

    @Test func testEmptyState() async throws {
        let store = TestStore(initialState: AccountPickerDomain.State()) {
            AccountPickerDomain()
        }
        assert(store.state.accounts.isEmpty)
        assert(store.state.selectedAccount == nil)
    }
}
