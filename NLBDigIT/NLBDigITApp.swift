//
//  NLBDigitApp.swift
//  NLBDigit
//
//  Created by Nikola on 7/13/26.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct NLBDigITApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: NewTransactionDomain.State()
                ) {
                    NewTransactionDomain()
                }
            )
        }
        .modelContainer(Persistence.sharedModelContainer)
    }
}
