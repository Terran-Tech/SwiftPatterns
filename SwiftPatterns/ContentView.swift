import SwiftUI

struct StatusDerivedIconExample: View {
    enum Status: String {
        case running, stopped, indeterminate, needsReboot
    }
    @State private var status: Status = .stopped

    // Derived
    var menuBarIcon: String {
        switch status {
            case .running:
                "network.badge.shield.half.filled"
            case .stopped:
                "network"
            case .indeterminate:
                "network.slash"
            case .needsReboot:
                "exclamationmark.triangle.fill"
        }
    }

    var body: some View {
        Label("Thing", systemImage: menuBarIcon)
    }

}

struct SidebarExample: View {
    // Selection tag
    @State private var selection: Set<Int> = [0]

    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink {
                    Text("View 1 content")
                } label: {
                    Label("Menu 1", systemImage: "network")
                }.tag(0)

                Divider()

                NavigationLink {
                    Text("View 2 content")
                } label: {
                    Label("Menu 2", systemImage: "gear")
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button() {
                        NSApp.sendAction(#selector(NSSplitViewController.toggleSidebar(_:)), to: nil, from: nil)
                    } label: {
                        Image(systemName: "sidebar.leading")
                    }
                    .help(String(localized: "Toggle sidebar"))
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationSplitViewStyle(.prominentDetail)
        .navigationBarBackButtonHidden()
        .frame(width: 550, height: 300)
        .onAppear() {
            selection = [0]
        }
    }
}

struct ContentView: View {
    var body: some View {
        SidebarExample()
    }
}

#Preview {
    ContentView()
}
