import AppKit
import Combine
import OSLog

/// Events for computer sleep/wake and screen lock/unlock.
enum ComputerEvent: String {
    /// Emitted when waking from sleep. Note that ``screenIsUnlocked`` may be emitted if user proceeds to unlock.
    case deviceAwakeFromSleep = "deviceAwakeFromSleep"
    /// Emitted when user puts the computer to sleep. Note that ``screenIsLocked`` may be emitted next automatically if autolock is enabled.
    case deviceWillSleep = "deviceWillSleep"
    /// Emitted when user locks the screen.
    case screenIsLocked = "screenIsLocked"
    /// Emitted when user unlocks the screen.
    case screenIsUnlocked = "screenIsUnlocked"
}

/// Get notifications when user locks, unlocks, sleeps or wakes up their computer
class ComputerSleepAndLock {
    private var cancellables: Set<AnyCancellable> = []

    init() {
        setupWorkspaceNotifications()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    func setupWorkspaceNotifications() {
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didWakeNotification)
            .sink { [weak self] _ in self?.onComputerEvent(.deviceAwakeFromSleep) }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.willSleepNotification)
            .sink { [weak self] _ in self?.onComputerEvent(.deviceWillSleep) }
            .store(in: &cancellables)

        DistributedNotificationCenter.default().publisher(for: Notification.Name(rawValue: "com.apple.screenIsLocked"))
            .sink { [weak self] _ in self?.onComputerEvent(.screenIsLocked) }
            .store(in: &cancellables)

        DistributedNotificationCenter.default().publisher(for: Notification.Name(rawValue: "com.apple.screenIsUnlocked"))
            .sink { [weak self] _ in self?.onComputerEvent(.screenIsUnlocked) }
            .store(in: &cancellables)
    }

    func onComputerEvent(_ event: ComputerEvent) {
        Logger.app.debug("On computer event \(event.rawValue)")
    }
}
