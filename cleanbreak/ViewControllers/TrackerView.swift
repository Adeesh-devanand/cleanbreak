import SwiftUI

struct TrackerView: View {
    @StateObject private var trackerData = TrackerDataModel()  // Using the model
    
    var body: some View {
        ZStack {
//            Color("DarkBlue")  // Set the entire background to black
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                            ZStack {
                                // Circular Progress Bar
                                CircularProgressBarView(progress: trackerData.calorieProgress)
                                    .frame(width: 200, height: 200)
                                
                                // Calories Info (Left & Right)
                                CaloriesOverlayView(consumed: trackerData.consumedCalories, remaining: trackerData.remainingCalories, offset: 25)

                            }
                            .padding()
                        
                
                // Macro Tracking Section
                HStack(spacing: 20) { // Adds spacing between bars
                    MacroBarView(label: "Protein", progress: trackerData.proteinProgress, color: .green)
                    MacroBarView(label: "Carbs", progress: trackerData.carbProgress, color: .orange)
                    MacroBarView(label: "Fats", progress: trackerData.fatProgress, color: .red)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 50) // Ensures horizontal layout
                
                Spacer()
        
                
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
            }
            .padding()
        }
    }
}

#Preview {
    TrackerView()
}
