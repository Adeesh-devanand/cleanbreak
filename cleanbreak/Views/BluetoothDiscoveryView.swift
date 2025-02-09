import SwiftUI

struct BluetoothDiscoveryView: View {
    var body: some View {
        ZStack {
            // Teal Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.8), Color.teal]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Centered Ripple Effect
                RippleEffectView()
                    .frame(width: 200, height: 200)
                
                Spacer()

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
                    Button(action: {
                        // Action for when user can't find device
                    }) {
                        Text("CAN'T FIND PRODUCT ?")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: 240)
                            .background(Color.white)
                            .foregroundColor(Color.teal)
                            .cornerRadius(100)
                    }
                    .padding(.top, 20) // Space from text above
                }
                .padding(.horizontal, 40) // Maintain horizontal spacing
                .padding(.vertical, 50)
            }
        }
    }
}

#Preview {
    BluetoothDiscoveryView()
}
