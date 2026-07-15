//
//  Persistence.swift
//  NLBDigit
//
//  Created by Nikola on 7/13/26.
//

import Foundation
import SwiftData

struct Persistence {
    
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TransactionModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, groupContainer: .identifier("group.com.nm-NLBDigit"))

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
