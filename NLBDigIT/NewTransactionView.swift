import SwiftUI
import ComposableArchitecture

struct NewTransactionView: View {
    let store: StoreOf<NewTransactionDomain>
    
    var body: some View {
        Button {
            store.send(.didTapCreate)
            
        } label: {
            Label("Add Item", systemImage: "plus")
            
        }
    }
}

#Preview {
    NewTransactionView(
        store: Store(
            initialState: NewTransactionDomain.State()
        ) {
            NewTransactionDomain()
        }
    )
}
