import SwiftUI

/**
 Demonstrates a layout with a sidebar and a content area.

 Note: NavigationView is deprecated as of macOS 14.2
 */
struct LayoutSidebar: View {
    // Item selected in the sidebar
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
            // Toggle sidebar visibility button, placed inside sidebar on top-right corner
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
        // Make sidebar translucent (popular effect in modern macOS apps)
        .listStyle(SidebarListStyle())
        .navigationSplitViewStyle(.prominentDetail)
        .navigationBarBackButtonHidden()
        .frame(width: 550, height: 300)
        .onAppear() {
            // Automatically select first item in sidebar to show its content
            selection = [0]
        }
    }
}
