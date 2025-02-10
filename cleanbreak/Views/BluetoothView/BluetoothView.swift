import SwiftUI

struct BluetoothView: View {
    @ObservedObject var trackerData: TrackerDataModel
    @State private var isBluetoothEnabled = false
    
    init(trackerData: TrackerDataModel, isBluetoothEnabled: Bool = false) {
        self.trackerData = trackerData
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.8), Color.teal]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if isBluetoothEnabled {
                // Bluetooth ON: Show Ripple Effect & Scanning UI

                VStack {
                    Spacer()

                    // Centered Ripple Effect
                    RippleEffectView()
                        .frame(width: 200, height: 200)
                        .padding()

                    // All text and button below
                    VStack(spacing: 2) {
                        // User's iPhone with Icon
                        HStack {
                            Image(systemName: "iphone") // iPhone symbol
                                .font(.title3)
                                .foregroundColor(.white)

                            Text("Adeesh's iPhone")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .opacity(0.5)

                        // Discovering Text
                        Text("Discovering product...")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        // "CAN'T FIND PRODUCT" Button
//                        Button(action: {
//                            // Action for when user can't find device
//                        }) {
//                            Text("CAN'T FIND PRODUCT ?")
//                                .fontWeight(.bold)
//                                .padding()
//                                .frame(maxWidth: 240)
//                                .background(Color.white)
//                                .foregroundColor(Color.teal)
//                                .cornerRadius(100)
//                        }
//                        .padding(.top, 20) // Space from text above
                    }
                    .padding(.horizontal, 40) // Maintain horizontal spacing
                    .padding(.vertical, 50)
                    
                    Spacer()
                    
                    HStack(spacing: 20){
                        Button(action: {
                            isBluetoothEnabled = false// Action for when user can't find device
                        }) {
                            Text("Turn off Bluetooth")
                                .fontWeight(.bold)
                                .font(.footnote)
                                .foregroundColor(Color.white)
                                .cornerRadius(100)
                        }
                        
                        Button(action: {
                            trackerData.isConnected = true
                        }) {
                            Text("Simulate Connect")
                                .fontWeight(.bold)
                                .font(.footnote)
                                .foregroundColor(Color.white)
                                .cornerRadius(100)
                        }
                    }
                }
            } else {
               VStack {
                   Spacer()
                   // Centered Ripple Effect
                   Image("bluetooth")
                       .resizable()
                       .scaledToFit()
                       .frame( maxWidth: 50, maxHeight: 100)
                       .foregroundColor(.white)
                       .opacity(0.5)
                   
                   // All text and button below
                   VStack(spacing: 2) {

                       // Discovering Text
                       Text("Turn on Bluetooth to discover nearby product.")
                           .font(.callout)
                           .frame(maxWidth:.infinity)
                           .fontWeight(.semibold)
                           .foregroundColor(.white)

                       // "CAN'T FIND PRODUCT" Button
                       Button(action: {
                           isBluetoothEnabled = true// Action for when user can't find device
                       }) {
                           Text("TURN ON")
                               .fontWeight(.bold)
                               .padding()
                               .frame(maxWidth: 120)
                               .background(Color.white)
                               .foregroundColor(Color.teal)
                               .cornerRadius(100)
                       }
                       .padding(.top, 20) // Space from text above
                   }
                   .padding(.vertical, 50)
                   
                   Spacer()
               }
            }
        }
    }
}

#Preview {
    BluetoothView(trackerData: TrackerDataModel())
}
