import SwiftUI

struct UnlockView: View {
    var size: CGFloat // Dynamic lock size
    var color: Color

    var body: some View {
        ZStack {
            // Lock Icon with Fade Animation
            Image(systemName: "lock.open.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.4, height: size * 0.4) // 40% of the arc size
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    UnlockView(size: 200, color: .green) // Testing with different sizes
}
