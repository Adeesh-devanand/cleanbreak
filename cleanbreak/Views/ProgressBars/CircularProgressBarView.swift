import SwiftUI

struct CircularProgressBarView: View {
    var progress: Float
    @State private var isBreathing = false  // Controls the "breathe" animation
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height) // Get the smallest dimension
                let iconSize = size * 0.4  // Set icon to 40% of the progress bar size
                
                ZStack {
                    // Background Glow (New Layer)
                    Circle()
                        .stroke(lineWidth: size * 0.075) // Scales dynamically
                        .opacity(0.2)
                        .foregroundColor(Color.mint)
                        .blur(radius: size * 0.1) // Scales glow dynamically
                    
                    // Background Circle (Subtle Outline)
                    Circle()
                        .stroke(lineWidth: size * 0.05)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    // Foreground Progress Arc (Mint Color)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.8), Color.mint]),
                                           startPoint: .leading,
                                           endPoint: .trailing),
                            style: StrokeStyle(lineWidth: size * 0.05, lineCap: .round)
                        )
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.easeInOut(duration: 1.0), value: progress)
                        .shadow(color: Color.mint.opacity(0.8), radius: size * 0.1, x: 0, y: 0)
                    
                    // Custom Logo in the Center (Tied to Progress Bar Size)
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize) // Scales dynamically
                        .foregroundColor(Color.mint)
                        .shadow(color: Color.mint.opacity(0.7), radius: size * 0.05, x: 0, y: 0) // Glow effect
                        .scaleEffect(isBreathing ? 1.15 : 1.0)  // Expands & contracts slightly more
                        .opacity(isBreathing ? 0.9 : 1.0)  // Slight fade effect
                        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isBreathing)
                        .onAppear {
                            isBreathing = true
                        }
                }
                .frame(width: size, height: size) // Ensure everything scales together
            }
            .aspectRatio(1, contentMode: .fit) // Maintain a square shape
            
//            // Percentage Below the Circle
//            Text("\(Int(progress * 100))%")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(.mint)
//                .shadow(color: Color.mint.opacity(0.7), radius: 5, x: 0, y: 0)
//                .padding(.top, 8)
        }
    }
}

#Preview {
    CircularProgressBarView(progress: 0.6)  // Example preview with 60% progress
        .frame(width: 200, height: 200)  // Example frame size
}
