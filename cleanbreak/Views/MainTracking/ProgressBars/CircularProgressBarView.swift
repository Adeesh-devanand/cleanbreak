import SwiftUI

struct CircularProgressBarView: View {
    var progress: Float
    var color: Color = .mint
    var isOffline: Bool // Determines animation mode
    
    @State private var isBreathing = false  // Controls the "breathe" animation
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let strokeWidth = size * 0.05
            let iconSize = size * 0.42
            
            ZStack {
                // Background Circle
                Circle()
                    .stroke(lineWidth: strokeWidth)
                    .opacity(0.2)
                    .foregroundColor(Color.white.opacity(0.3))
                
                // Foreground Progress Arc
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [color.opacity(0.6), color]),
                                       startPoint: .leading,
                                       endPoint: .trailing),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                    .shadow(color: color.opacity(0.8), radius: size * 0.1, x: 0, y: 0)
                
                // Center Logo with Dynamic Animation
                Image("Logo")  // Replace with your actual asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize) // Adjust as needed
                    .foregroundColor(Color.mint)
                    .shadow(color: Color.mint.opacity(0.7), radius: 5, x: 0, y: 0) // Light glow
                    .scaleEffect(isBreathing ? 1.1 : 1.0)  // Expands & contracts
                    .animation(Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true), value: isBreathing)
                    .onAppear {
                        isBreathing = true
                    }
                            

            }
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    CircularProgressBarView(progress: 0.6, isOffline: false)
        .frame(width: 200, height: 200)
}
