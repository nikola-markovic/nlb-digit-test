//
//  NLBDigitApp.swift
//  NLBDigit
//
//  Created by Nikola on 7/13/26.
//

import SwiftUI
import SwiftData

@main
struct NLBDigITApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(Persistence.sharedModelContainer)
    }
}
