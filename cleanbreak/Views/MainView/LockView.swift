import SwiftUI

struct LockView: View {
    var size: CGFloat // Dynamic lock size
    var color: Color
    @State private var fadeInOut = false // Controls fade animation

    var body: some View {
        ZStack {
            // Lock Icon with Fade Animation
            Image(systemName: "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.4, height: size * 0.4) // 40% of the arc size
                .foregroundColor(color)
                .opacity(fadeInOut ? 1 : 0.5) // Fades in and out
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: fadeInOut
                )
        }
        .frame(width: size, height: size)
        .onAppear {
            fadeInOut = true
        }
    }
}

#Preview {
    LockView(size: 200, color: .mint) // Testing with different sizes
}
