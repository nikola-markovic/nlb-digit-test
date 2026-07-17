import Foundation
import SwiftData

struct Persistence {
    
    static let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TransferModel.self,
            AccountModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, groupContainer: .identifier("group.com.nm-NLBDigit"))
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            let accounts = try container.mainContext.fetch(FetchDescriptor<AccountModel>())
            if accounts.isEmpty {
                for item in initialData {
                    container.mainContext.insert(item)
                }
            }
            try container.mainContext.save()

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let initialData = [
        AccountModel(id: "142-123456-78", balance: 1000, transfers: []),
        AccountModel(id: "142-Credit-70", balance: 2000, transfers: []),
        AccountModel(id: "142-Saving-77", balance: 0, transfers: []),
    ]
}
