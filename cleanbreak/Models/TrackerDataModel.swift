import SwiftUI
import Combine

enum TimerState {
    case locked
    case unlocked
}

class TrackerDataModel: ObservableObject {
    // These properties are updated from BluetoothManager
    @Published var persistentTotal: CGFloat = 0   // in ms
    @Published var persistentElapsed: CGFloat = 0 // in ms
    @Published var coilTotal: CGFloat = 0         // in ms
    @Published var coilElapsed: CGFloat = 0         // in ms
    
    // Derived properties for UI:
    @Published var state: TimerState = .locked
    @Published var progress: CGFloat = 0

    private var cancellables: Set<AnyCancellable> = []
    
    init(bluetoothManager: MockBluetoothManager) {
        // Subscribe to changes from BluetoothManager.
        bluetoothManager.$persistentTotal
            .sink { [weak self] newValue in
                self?.persistentTotal = newValue
                self?.updateStateAndProgress()
            }
            .store(in: &cancellables)
        
        bluetoothManager.$persistentElapsed
            .sink { [weak self] newValue in
                self?.persistentElapsed = newValue
                self?.updateStateAndProgress()
            }
            .store(in: &cancellables)
        
        bluetoothManager.$coilTotal
            .sink { [weak self] newValue in
                self?.coilTotal = newValue
                self?.updateStateAndProgress()
            }
            .store(in: &cancellables)
        
        bluetoothManager.$coilElapsed
            .sink { [weak self] newValue in
                self?.coilElapsed = newValue
                self?.updateStateAndProgress()
            }
            .store(in: &cancellables)
    }
    
    private func updateStateAndProgress() {
        // Determine state:
        if persistentElapsed < persistentTotal {
            state = .locked
            // Locked state: progress counts up
            progress = persistentTotal > 0 ? persistentElapsed / persistentTotal : 0
        } else {
            state = .unlocked
            // Unlocked state: if the coil timer is running, count down,
            // otherwise, assume progress is full (1.0)
            if coilTotal > 0 && coilElapsed > 0 {
                progress = 1.0 - (coilElapsed / coilTotal)
            } else {
                progress = 1.0
            }
        }
    }
    
    // Formats remaining time based on current state.
    func formatTime() -> String {
        let remaining: CGFloat
        if state == .locked {
            remaining = persistentTotal - persistentElapsed
        } else {
            remaining = coilTotal - coilElapsed
        }
        let totalSeconds = Int(remaining / 1000)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%dm %ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
}
