import SwiftUI

struct CalorieTextView: View {
    var label: String
    var value: Float
    var alignment: Alignment
    var color: Color = .teal
    
    @State private var animatedValue: Float = 0 // Used for smooth animation
    @State private var isAnimating = false // Controls animation state

    var body: some View {
        VStack {
            Text("\(Int(animatedValue))") // Animate the value
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: 5)
                .scaleEffect(isAnimating ? 1.2 : 1.0) // Slight zoom effect
                .opacity(isAnimating ? 0.8 : 1.0) // Fade effect
                .animation(.easeInOut(duration: 0.5), value: isAnimating)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: alignment)
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
}

#Preview {
    VStack {
        CalorieTextView(label: "Consumed", value: 1200, alignment: .leading)
        CalorieTextView(label: "Remaining", value: 800, alignment: .trailing)
    }
    .padding()
    .background(Color.black)
}
