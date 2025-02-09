import SwiftUI
import Combine

class TrackerDataModel: ObservableObject {
    @Published var totalMinutes: CGFloat = 180  // Total duration (e.g., 3 hours)
    @Published var remainingMinutes: CGFloat = 135  // Time left (e.g., 2h 15m)

    var progress: CGFloat {
        return 1 - (remainingMinutes / totalMinutes) // Convert remaining time to progress (0-1)
    }

    func updateTime(by minutes: CGFloat) {
        remainingMinutes = max(remainingMinutes - minutes, 0) // Decrease time safely
    }

    func formatTime() -> String {
        let hours = Int(remainingMinutes) / 60
        let mins = Int(remainingMinutes) % 60

        if hours >= 6 {
            return "\(hours)h" // Show only hours if hours >= 10
        } else if hours > 0 {
            return "\(hours)h \(mins)m" // Show both hours and minutes if hours is 1-9
        } else {
            return "\(mins)m" // Show only minutes if hours is 0
        }
    }
}
