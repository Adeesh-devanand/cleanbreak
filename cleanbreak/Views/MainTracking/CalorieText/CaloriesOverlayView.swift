import SwiftUI

struct CaloriesOverlayView: View {
    var consumed: Float
    var remaining: Float
    var offsetX: CGFloat
    var offsetY: CGFloat
    var color: Color = .teal

    var body: some View {
        ZStack {
            // Left: Consumed Calories
            CalorieTextView(label: "Elapsed", value: consumed, alignment: .leading)
                .offset(x: -offsetX, y: offsetY) // Move text outward

            // Right: Remaining Calories
            CalorieTextView(label: "Remaining", value: remaining, alignment: .trailing)
                .offset(x: offsetX, y: offsetY) // Move text outward
        }
    }
}

#Preview {
    CaloriesOverlayView(consumed: 1200, remaining: 800, offsetX: 140, offsetY: 120)
        .frame(width: 300, height: 150)
        .background(Color.black)
}
