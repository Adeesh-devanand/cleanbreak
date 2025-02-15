import SwiftUI
import Combine

class MockBluetoothManager: ObservableObject {
    // Published properties to mimic BluetoothManager's values
    @Published var isConnected: Bool = false
    @Published var persistentTotal: CGFloat = 180    // Example: 180 seconds total for persistent timer
    @Published var persistentElapsed: CGFloat = 0      // Elapsed time for persistent timer
    @Published var coilTotal: CGFloat = 60             // Example: 60 seconds total for coil timer
    @Published var coilElapsed: CGFloat = 0            // Elapsed time for coil timer

    // Cancellables for the countdown timers
    private var persistentTimerCancellable: AnyCancellable?
    private var coilTimerCancellable: AnyCancellable?
    
    // Simulate a Bluetooth connect event
    func simulateConnect() {
        isConnected = true
        // Reset persistent timer and start counting
        persistentElapsed = 0
        startPersistentCountdown()
    }
    
    // Start the persistent timer countdown
    public func startPersistentCountdown() {
        persistentTimerCancellable?.cancel()
        persistentTimerCancellable = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.persistentElapsed < self.persistentTotal {
                    self.persistentElapsed += 1
                } else {
                    self.persistentTimerCancellable?.cancel()
                }
            }
    }
    
    // Simulate starting the coil timer.
    // Note: When the coil timer starts, the persistent timer is considered ended.
    func simulateStartCoilTimer() {
        // Stop the persistent timer countdown
        persistentTimerCancellable?.cancel()
        // Set persistentElapsed to total to simulate that the persistent timer has finished
        persistentElapsed = persistentTotal
        // Reset and start the coil countdown
        coilElapsed = 0
        startCoilCountdown()
    }
    
    // Start the coil timer countdown
    public func startCoilCountdown() {
        coilTimerCancellable?.cancel()
        coilTimerCancellable = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.coilElapsed < self.coilTotal {
                    self.coilElapsed += 1
                } else {
                    self.coilTimerCancellable?.cancel()
                    // When coil timer ends, reset the persistent timer and start its countdown automatically.
                    self.resetPersistentTimer()
                    self.startPersistentCountdown()
                }
            }
    }
    
    // Resets the persistent timer
    func resetPersistentTimer() {
        persistentElapsed = 0
    }
}
