import SwiftUI

struct DeviceStatusBar: View {
    var label: String
    var progress: CGFloat
    var color: Color = .mint

    var body: some View {
        VStack(alignment: .center) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background Bar
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 10)
                        .foregroundColor(Color.gray.opacity(0.3))

                    // Foreground Progress Bar (Mint)
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width),
                               height: 10)
                        .foregroundColor(color)
                        .shadow(color: color.opacity(0.9), radius: 5, x: 0, y: 0)
                        .animation(.easeInOut(duration: 0.7), value: progress)
                }
            }
            .frame(height: 10)
        }
        .frame(width: 140) // Adjusted width to fit inside HStack
        .padding(.vertical, 5)
    }
}

#Preview {
    HStack(spacing: 20) {
        DeviceStatusBar(label: "Juice", progress: 0.75)
        DeviceStatusBar(label: "Battery", progress: 0.5)
    }
    .padding()
    .background(Color.black)
}
