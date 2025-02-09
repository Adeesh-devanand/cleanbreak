import SwiftUI

struct TrackerView: View {
    @StateObject private var trackerData = TrackerDataModel()  // Using the model
    
    var body: some View {
        ZStack {
            Color("DarkBlue")  // Set the entire background to black
                .ignoresSafeArea()
            
            VStack {
                Text("Today's Calories")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)  // White for contrast
                    .padding(.top, 20)
                
                // Circular Progress Bar
                CircularProgressBarView(progress: trackerData.calorieProgress)
                    .frame(width: 200, height: 200)
                    .padding()
                
                // Macro Tracking Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Macros Breakdown")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    // Macro Progress Bars (dynamic values)
                    MacroBarView(label: "Protein", progress: trackerData.proteinProgress, color: .green)
                    MacroBarView(label: "Carbs", progress: trackerData.carbProgress, color: .orange)
                    MacroBarView(label: "Fats", progress: trackerData.fatProgress, color: .red)
                }
                .padding()
                
                // Button to Simulate Data Update (Replace with Bluetooth later)
                Button(action: {
                    trackerData.updateData()
                }) {
                    Text("Add Intake")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 5) // Soft glow effect
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    TrackerView()
}
