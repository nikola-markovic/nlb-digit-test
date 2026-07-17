import SwiftUI
import SwiftData
import ComposableArchitecture
import SwiftfulRouting

struct TransfersView: View {
    @Environment(\.router) private var router
    @Environment(\.modelContext) private var modelContext
    
    var accountId: String
    
    @Query private var items: [TransferModel]
    
    init(accountId: String) {
        self.accountId = accountId
        _items = Query(
            filter: #Predicate<TransferModel> {
                $0.sourceAccount?.id == accountId
                || $0.destinationAccount?.id == accountId
            },
            sort: \TransferModel.timestamp,
            order: .forward,
            animation: .easeIn
        )
    }

    var body: some View {
        Group {
            if items.isEmpty {
                VStack {
                    Spacer()
                    Text("There are no Transfers for this account.\nTry another account or make a new transfer.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            } else {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            TransferDetailsView(transfer: item, selectedAccountId: accountId)
                        } label: {
                            TransferCellView(transfer: item, selectedAccountId: accountId)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
        .navigationTitle("Transfers")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button {
                    let newTransferStore = Store(initialState: NewTransferDomain.State()) {
                        NewTransferDomain()
                    }
                    router.showScreen(.push) { router in
                        NewTransferView(store: newTransferStore, preloadedAccountId: accountId)
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
