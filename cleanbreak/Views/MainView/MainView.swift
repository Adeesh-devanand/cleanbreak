import SwiftUI

struct MainView: View {
    @ObservedObject private var trackerData: TrackerDataModel
    
    init(trackerData: TrackerDataModel) {
        self.trackerData = trackerData
    }
    
    var color: Color {
        return trackerData.progress == 1 ? .green : .mint
        }    //    var color: Gradient = Gradient(colors: [Color.mint.opacity(0.8), Color.teal])

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            VStack {
                Text("Connected: \(trackerData.productName)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                

                // Lock Timer with Time Display
                TimerArc(color: color, gapAngle: 50, progress: trackerData.progress, time: trackerData.formatTime())
                    .frame(width: 250, height: 250)
                    .padding(.top, 80)

                // Horizontal Device Status Bars (Juice & Battery)
                HStack(spacing: 35) {
                    DeviceStatusBar(color: color, label: "Juice", progress: trackerData.juiceLevel)
                    DeviceStatusBar(color: color, label: "Battery", progress: trackerData.batteryLevel)
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
    MainView(trackerData: TrackerDataModel())
}
