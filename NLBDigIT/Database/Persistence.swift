//
//  Persistence.swift
//  NLBDigit
//
//  Created by Nikola on 7/13/26.
//

import Foundation
import SwiftData

struct Persistence {
    
    static let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TransactionModel.self,
            AccountModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, groupContainer: .identifier("group.com.nm-NLBDigit"))
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            for item in initialData {
                container.mainContext.insert(item)
            }
            try container.mainContext.save()

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let initialData = [
        AccountModel(id: "142-12-34", balance: 1000, currency: "EUR", transactions: [], cards: [], user: nil),
        AccountModel(id: "142-Credit-70", balance: 2000, currency: "EUR", transactions: [], cards: [], user: nil),
    ]
}
