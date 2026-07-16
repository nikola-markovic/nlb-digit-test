import SwiftUI
import SwiftData
import ComposableArchitecture
import SwiftfulRouting

struct ContentView: View {
    @Environment(\.router) var router
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TransactionModel]
    
    @State private var newTransactionStore = Store(initialState: NewTransactionDomain.State()) {
        NewTransactionDomain()
    }

    var body: some View {
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
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button {
                    router.showScreen(.push) { router in
                        NewTransactionView(store: newTransactionStore)
                    }
                } label: {
                    Label("Add Item", systemImage: "plus")
                    
                }
            }
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
    ContentView()
    .modelContainer(Persistence.sharedModelContainer)
}
