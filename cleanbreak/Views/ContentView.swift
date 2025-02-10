import SwiftUI

struct ContentView: View {
    @StateObject private var trackerData = TrackerDataModel()

    var body: some View {
        ZStack {
            if trackerData.isConnected {
                // Show TrackerView when connected
                TrackerView(trackerData: trackerData)
                    .transition(.slide) // Smooth transition
                    .onAppear {
                        trackerData.startCountdown() 
                    }
            } else {
                // Show BluetoothDiscoveryView when disconnected
                BluetoothView(trackerData: trackerData)
                    .transition(.slide) // Smooth transition
            }
        }
        .animation(.easeInOut(duration: 0.5), value: trackerData.isConnected)
    }
}

#Preview {
    ContentView()
}
