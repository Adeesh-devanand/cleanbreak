import SwiftUI
import Combine

class TrackerDataModel: ObservableObject {
    @Published var totalCalories: Float = 2000  // Daily goal
    @Published var consumedCalories: Float = 1200  // Consumed so far
    
    @Published var proteinGoal: Float = 150  // in grams
    @Published var carbsGoal: Float = 250
    @Published var fatsGoal: Float = 70
    
    @Published var consumedProtein: Float = 75
    @Published var consumedCarbs: Float = 180
    @Published var consumedFats: Float = 40
    
    // Computed properties to get progress percentages
    var calorieProgress: Float {
        return min(consumedCalories / totalCalories, 1.0)
    }
    
    var proteinProgress: Float {
        return min(consumedProtein / proteinGoal, 1.0)
    }
    
    var carbProgress: Float {
        return min(consumedCarbs / carbsGoal, 1.0)
    }
    
    var fatProgress: Float {
        return min(consumedFats / fatsGoal, 1.0)
    }
    
    // Function to simulate data updates (replace with Bluetooth later)
    func updateData() {
        self.consumedCalories += 50
        self.consumedProtein += 5
        self.consumedCarbs += 10
        self.consumedFats += 2
        
        // Ensure values do not exceed the goal
        self.consumedCalories = min(self.consumedCalories, self.totalCalories)
        self.consumedProtein = min(self.consumedProtein, self.proteinGoal)
        self.consumedCarbs = min(self.consumedCarbs, self.carbsGoal)
        self.consumedFats = min(self.consumedFats, self.fatsGoal)
    }
}
