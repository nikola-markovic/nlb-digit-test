import SwiftUI
import SwiftData
import ComposableArchitecture
import SwiftfulRouting

@main
struct NLBDigITApp: App {

    var body: some Scene {
        WindowGroup {
            RouterView { router in
                HomeView()
            }
            .tint(Color.indigo)
        }
        .modelContainer(Persistence.sharedModelContainer)
    }
}
