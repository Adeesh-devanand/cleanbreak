import SwiftUI

struct CaloriesOverlayView: View {
    var consumed: Float
    var remaining: Float
    var offset: CGFloat
    var color: Color = .teal

    var body: some View {
        ZStack {
            // Left: Consumed Calories
            CalorieTextView(label: "Consumed", value: consumed, alignment: .leading)
                .offset(x: -offset * 0.5, y: offset * 3.5) // Move text outward

            // Right: Remaining Calories
            CalorieTextView(label: "Remaining", value: remaining, alignment: .trailing)
                .offset(x: offset * 0.5, y: offset * 3.5) // Move text outward
        }
    }
}

#Preview {
    CaloriesOverlayView(consumed: 1200, remaining: 800, offset: 30)
        .frame(width: 300, height: 150)
        .background(Color.black)
}
