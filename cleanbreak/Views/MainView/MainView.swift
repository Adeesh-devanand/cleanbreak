import SwiftUI

struct MainView: View {
    @StateObject private var trackerData = TrackerDataModel()

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            VStack {
                Text(trackerData.productName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .frame(width: 250, height: 50)
                
                Spacer()

                // Lock Timer with Time Display
                TimerArc(gapAngle: 50, trackerData: trackerData)
                    .frame(width: 250, height: 250)

                // Horizontal Device Status Bars (Juice & Battery)
                HStack(spacing: 35) {
                    DeviceStatusBar(label: "Juice", progress: trackerData.juiceLevel)
                    DeviceStatusBar(label: "Battery", progress: trackerData.batteryLevel)
                }
                .padding(.top, 40)
                .padding(.horizontal, 30) // Reduce horizontal padding for better spacing
                .frame(maxWidth: .infinity, minHeight: 50)

                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
