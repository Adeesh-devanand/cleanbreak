import SwiftUI

struct CalorieTextView: View {
    var label: String
    var value: Float // Represents time in minutes
    var alignment: Alignment
    var color: Color = .teal

    @State private var animatedValue: Float = 0 // Used for smooth animation
    @State private var isAnimating = false // Controls animation state

    var body: some View {
        VStack {
            Text(formatTime(value)) // Animate the value
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
//                .shadow(color: color.opacity(0.5), radius: 5)
//                .scaleEffect(isAnimating ? 1.2 : 1.0) // Slight zoom effect
//                .opacity(isAnimating ? 0.8 : 1.0) // Fade effect
//                .animation(.easeInOut(duration: 0.5), value: isAnimating)

            Text(label)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: 150, alignment: alignment)
        .onAppear {
            animatedValue = value // Set initial value
        }
        .onChange(of: value) {  // New syntax (no need for `newValue`)
            withAnimation {
                isAnimating = true
                animatedValue = value // Animate value change
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnimating = false // Reset animation after 0.5s
            }
        }
    }


    // Converts minutes into "X hrs Y min"
    private func formatTime(_ minutes: Float) -> String {
        let hours = Int(minutes) / 60
        let mins = Int(minutes) % 60
        return hours > 0 ? "\(hours) hrs \(mins) min" : "\(mins) min"
    }
}

#Preview {
    VStack {
        CalorieTextView(label: "Elapsed", value: 120, alignment: .leading) // 2 hrs 0 min
        CalorieTextView(label: "Remaining", value: 75, alignment: .trailing) // 1 hr 15 min
    }
    .padding()
    .background(Color.black)
}
