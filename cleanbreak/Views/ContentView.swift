import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager: MockBluetoothManager
        @StateObject private var trackerData: TrackerDataModel

        init(bluetoothManager: MockBluetoothManager = MockBluetoothManager()) {
            _bluetoothManager = StateObject(wrappedValue: bluetoothManager)
            _trackerData = StateObject(wrappedValue: TrackerDataModel(bluetoothManager: bluetoothManager))
        }

    var body: some View {
        ZStack {
            if bluetoothManager.isConnected {
                // Show TrackerView when connected
                TrackerView(trackerData: trackerData, bluetoothManager: bluetoothManager)
                    .transition(.slide) // Smooth transition
                    .onAppear {
                        bluetoothManager.simulateConnect()
                    }
            } else {
                // Show BluetoothDiscoveryView when disconnected
                BluetoothView(bluetoothManager: bluetoothManager)
                    .transition(.slide) // Smooth transition
            }
        }
        .animation(.easeInOut(duration: 0.5), value: bluetoothManager.isConnected)
    }
}

#Preview {
    ContentView()
}
