import SwiftUI
import Combine

class TrackerDataModel: ObservableObject {
    // Bluetooth connection properties
    @Published var isConnected: Bool = false
    @Published var peripheralName: String = "Unknown Device"

    // Timer and progress tracking
    @Published var totalMinutes: CGFloat = 180  // Total duration (e.g., 3 hours)
    @Published var timeElapsed: CGFloat = 175  // Time left (e.g., 2h 15m)

    // Device levels
    @Published var juiceLevel: CGFloat = 1.0
    @Published var batteryLevel: CGFloat = 0.5

    var productName: String {
        return "Clean Break v1.2"
    }

    private var bluetoothManager: MockBluetoothManager
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?

    init() {
        self.bluetoothManager = MockBluetoothManager()
//        bindToBluetoothManager()
    }

    /// Observes changes from BluetoothManager and updates UI properties
    private func bindToBluetoothManager() {
        bluetoothManager.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)

        bluetoothManager.$peripheralName
            .receive(on: DispatchQueue.main)
            .assign(to: &$peripheralName)

        bluetoothManager.$totalTimer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.totalMinutes = newValue
            }
            .store(in: &cancellables)

        bluetoothManager.$timeElapsed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.timeElapsed = newValue
            }
            .store(in: &cancellables)

        bluetoothManager.$juiceLevel
            .receive(on: DispatchQueue.main)
            .assign(to: &$juiceLevel)

        bluetoothManager.$batteryLevel
            .receive(on: DispatchQueue.main)
            .assign(to: &$batteryLevel)
    }
    
    /// Starts a countdown timer
    public func startCountdown() {
        self.timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 2, on: .main, in: .common)  // Update every minute
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeElapsed < self.totalMinutes {
                    self.timeElapsed += 1  // Increase elapsed time
                } else {
                    self.timerCancellable?.cancel()  // Stop the timer when time runs out
                }
            }
    }


    var progress: CGFloat {
        return min (1, timeElapsed / totalMinutes) // Convert remaining time to progress (0-1)
    }

    func formatTime() -> String {
        let hours = Int(totalMinutes - timeElapsed) / 60
        let mins = Int(totalMinutes - timeElapsed) % 60

        if hours >= 6 {
            return "\(hours)h" // Show only hours if hours >= 6
        } else if hours > 0 {
            return "\(hours)h \(mins)m" // Show both hours and minutes if hours is 1-5
        } else {
            return "\(mins)m" // Show only minutes if hours is 0
        }
    }
}
