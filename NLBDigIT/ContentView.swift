import SwiftUI
import SwiftData
import ComposableArchitecture
import SwiftfulRouting

struct ContentView: View {
    @Environment(\.router) var router
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TransferModel]
    
    @State private var newTransferStore = Store(initialState: NewTransferDomain.State()) {
        NewTransferDomain()
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
        .navigationTitle("Transfers")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button {
                    newTransferStore = Store(initialState: NewTransferDomain.State()) {
                        NewTransferDomain()
                    }
                    router.showScreen(.push) { router in
                        NewTransferView(store: newTransferStore)
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
