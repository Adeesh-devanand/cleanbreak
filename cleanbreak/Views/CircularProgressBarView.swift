import SwiftUI

struct CircularProgressBarView: View {
    var progress: Float
    
    var body: some View {
        ZStack {
            // Background Glow (New Layer)
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.15)
                .foregroundColor(Color.blue)
                .blur(radius: 15) // Adds a soft glow
            
            // Background Circle (Faint Glow)
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            // Foreground Progress Arc (Neon Effect)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                   startPoint: .leading,
                                   endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0), value: progress)
                .shadow(color: Color.blue.opacity(0.9), radius: 15, x: 0, y: 0)  // Stronger glow effect
            
            // Text inside the circle
            Text("\(Int(progress * 100))%")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: Color.blue.opacity(0.7), radius: 5, x: 0, y: 0) // Light text glow
        }
    }
}

#Preview {
    CircularProgressBarView(progress: 0.6)  // Example preview with 60% progress
    
}
