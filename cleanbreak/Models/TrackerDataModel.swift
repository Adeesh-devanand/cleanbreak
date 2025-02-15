import SwiftUI
import Combine

class TrackerDataModel: ObservableObject {
    // Bluetooth connection properties
    @Published var persistentTotal: CGFloat = 0
    @Published var persistentElapsed: CGFloat = 0
    @Published var coilTotal: CGFloat = 0
    @Published var coilElapsed: CGFloat = 0
    
    // Computed state: if persistentElapsed < persistentTotal, then the device is locked.
    // Otherwise, it’s unlocked.
    var state: TimerState {
        return persistentElapsed < persistentTotal ? .locked : .unlocked
    }
    
    /// Starts a countdown timer
    public func startCountdown() {
        self.timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 2, on: .main, in: .common)  // Update every minute
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.persistentElapsed < self.totalMinutes {
                    self.persistentElapsed += 1  // Increase elapsed time
                } else {
                    self.timerCancellable?.cancel()  // Stop the timer when time runs out
                }
            }
    }


    var progress: CGFloat {
        if state == .locked {
            return persistentTotal > 0 ? persistentElapsed / persistentTotal : 0
        } else {
            // If the coil timer is running, count down; if not, assume progress is full.
            return coilTotal > 0 && coilElapsed > 0 ? 1.0 - (coilElapsed / coilTotal) : 1.0
        }
    }

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
