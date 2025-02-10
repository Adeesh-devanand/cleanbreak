import SwiftUI

class MockBluetoothManager: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var peripheralName: String = "Mock Device"
    
    @Published var totalTimer: CGFloat = 180  // Default total time (e.g., 3 hours)
    @Published var timeElapsed: CGFloat = 130  // Time elapsed
    @Published var juiceLevel: CGFloat = 0.75  // 75% juice remaining
    @Published var batteryLevel: CGFloat = 0.5  // 50% battery remaining

    var progress: CGFloat {
        return timeElapsed / totalTimer
    }

    // MARK: - Public Functions for Unit Testing

    /// Simulates connecting to a peripheral
    public func simulateConnection(_ connected: Bool, name: String = "Mock Device") {
        isConnected = connected
        peripheralName = name
    }

    /// Simulates updating time elapsed
    public func updateTimeElapsed(by minutes: CGFloat) {
        timeElapsed = min(timeElapsed + minutes, totalTimer)
    }

    /// Simulates updating juice level
    public func updateJuiceLevel(_ level: CGFloat) {
        juiceLevel = max(0, min(level, 1.0)) // Clamp between 0 and 1
    }

    /// Simulates updating battery level
    public func updateBatteryLevel(_ level: CGFloat) {
        batteryLevel = max(0, min(level, 1.0)) // Clamp between 0 and 1
    }

    /// Simulates resetting the timer
    public func resetTimer() {
        timeElapsed = 0
    }
}
