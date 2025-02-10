import SwiftUI

struct BluetoothView: View {
    @State private var isBluetoothEnabled = false // Toggle Bluetooth status

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
                           .font(.footnote)
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
                   .padding(.horizontal, 40) // Maintain horizontal spacing
                   .padding(.vertical, 50)
                   
                   Spacer()
               }
            }
        }
        .onAppear {
            checkBluetoothStatus()
        }
    }

    // Simulate checking Bluetooth status (replace with real check)
    private func checkBluetoothStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isBluetoothEnabled = false // Simulate Bluetooth being off initially
        }
    }
}

#Preview {
    BluetoothView()
}
