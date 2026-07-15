import SwiftUI
import SwiftData
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<NewTransactionDomain>
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TransactionModel]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NewTransactionView(store: store)
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(
            initialState: NewTransactionDomain.State()
        ) {
            NewTransactionDomain()
        }
    )
    .modelContainer(Persistence.sharedModelContainer)
}
