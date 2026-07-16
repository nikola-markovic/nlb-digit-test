//
//  NLBDigitApp.swift
//  NLBDigit
//
//  Created by Nikola on 7/13/26.
//

import SwiftUI
import SwiftData
import ComposableArchitecture
import SwiftfulRouting

@main
struct NLBDigITApp: App {

    var body: some Scene {
        WindowGroup {
            RouterView { router in
                ContentView()
            }
            .tint(Color.indigo)
        }
        .modelContainer(Persistence.sharedModelContainer)
    }
}
