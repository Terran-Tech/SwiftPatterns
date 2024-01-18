import SwiftUI

@main
struct SwiftPatternsApp: App {
    var body: some Scene {
        // Make window unresizable (fixedSize() + .contentSize)
        WindowGroup {
            ContentView().fixedSize()
        }.windowResizability(.contentSize)
    }
}
