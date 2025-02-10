import SwiftUI

struct DeviceStatusBar: View {
    var color: Color
    var label: String
    var progress: CGFloat

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
                        .foregroundColor(color.opacity(0.4))

                    // Foreground Progress Bar (Mint)
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width),
                               height: 10)
                        .foregroundColor(color)
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
        DeviceStatusBar(color: .mint, label: "Juice", progress: 0.75)
        DeviceStatusBar(color: .mint, label: "Battery", progress: 0.5)
    }
    .padding()
    .background(Color.black)
}
