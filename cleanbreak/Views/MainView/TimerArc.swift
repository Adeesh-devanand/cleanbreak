import SwiftUI

import SwiftUI

struct TimerArc: View {
    var color: Color
    var gapAngle: Double = 15 // Change this to control the bottom gap size
    var progress: CGFloat
    var time: String

    

    var body: some View {
        
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let strokeWidth = size * 0.05
            let totalArc: Double = 360 - gapAngle
            let startAngle: Double = -270 + (gapAngle / 2)
            let endAngle: Double = startAngle + (Double(progress) * totalArc)

            ZStack {
                // Background Arc (Full Outline)
                ArcShape(startAngle: startAngle, endAngle: 90 - (gapAngle / 2))
                    .stroke(color.opacity(0.4), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))

                // Foreground Progress Arc (Now updates with high precision)
                ArcShape(startAngle: startAngle, endAngle: endAngle)
                    .stroke(color, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .animation(.easeInOut(duration: 1), value: progress) // Ensures smooth updates
                
                // Lock Animation at the Center (Dynamic Size)
                
                if (progress == 1) {
                    UnlockView(size: size, color: color)

                } else {
                    LockView(size: size, color: color)
                }
                
                                
                // Time Remaining Displayed in the Gap
                Text(time)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .position(x: size / 2, y: size * 1) // Place at the bottom gap
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// Custom Arc Shape with Rounded Edges
struct ArcShape: Shape {
    var startAngle: Double
    var endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )
        return path
    }
}

#Preview {
    TimerArc(color: .mint, gapAngle: 50, progress: 0.1, time: "1h")
            .frame(width: 200, height: 200)
}
