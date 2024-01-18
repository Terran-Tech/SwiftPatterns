import SwiftUI

struct DynamicIcon: View {
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
