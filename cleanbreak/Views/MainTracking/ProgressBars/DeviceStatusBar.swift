import SwiftUI

struct DeviceStatusBar: View {
    var label: String
    var progress: Float
    var color: Color  // Different colors for each macro
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background Bar (Soft Glow)
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 10)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 0) // Faint background glow
                    
                    // Foreground Progress Bar (Glowing)
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width),
                               height: 10)
                        .foregroundColor(color)
                        .shadow(color: color.opacity(0.9), radius: 10, x: 0, y: 0) // Stronger glow
                        .animation(.easeInOut(duration: 0.7), value: progress)
                }
            }
            .frame(height: 10)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    VStack {
        DeviceStatusBar(label: "Juice", progress: 0.75, color: .green)
        DeviceStatusBar(label: "Battery", progress: 0.5, color: .orange)
    }
    .padding()
}
