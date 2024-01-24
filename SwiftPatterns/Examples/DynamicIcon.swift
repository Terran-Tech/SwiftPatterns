import SwiftUI

struct DynamicIcon: View {
    enum Status: Int {
        case running = 0, stopped, indeterminate, needsReboot
    }
    @State private var status: Status = .stopped

    func nextStatus() -> Status {
        Status(rawValue: (status.rawValue + 1) % 4)!
    }

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
        VStack {
            Label("Thing", systemImage: menuBarIcon)
            Button("Toggle next status") {
                status = nextStatus()
            }
        }.padding()
    }

}

#Preview {
    DynamicIcon()
}
