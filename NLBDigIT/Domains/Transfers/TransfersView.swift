import SwiftUI
import SwiftData
import ComposableArchitecture
import SwiftfulRouting

struct TransfersView: View {
    @Environment(\.router) private var router
    @Environment(\.modelContext) private var modelContext
    
    var accountId: String
    
    @Query private var items: [TransferModel]
    @State private var newTransferStore = Store(initialState: NewTransferDomain.State()) {
        NewTransferDomain()
    }
    
    init(accountId: String) {
        self.accountId = accountId
        _items = Query(
            filter: #Predicate<TransferModel> {
                $0.sourceAccount?.id == accountId
            },
            sort: \TransferModel.timestamp,
            order: .forward,
            animation: .easeIn
        )
    }

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    TransferCellView(transfer: item)
                } label: {
                    TransferCellView(transfer: item)
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
    TransfersView(accountId: Persistence.initialData.first!.id)
        .modelContainer(Persistence.sharedModelContainer)
}
