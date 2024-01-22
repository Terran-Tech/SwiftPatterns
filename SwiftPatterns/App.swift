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

struct ContentView: View {
    var body: some View {
        // Place here any of the examples in Examples/
        AlertsView()
    }
}

#Preview {
    ContentView()
}
