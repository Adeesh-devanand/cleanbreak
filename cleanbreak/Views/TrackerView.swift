import SwiftUI

struct TrackerView: View {
    @State private var selectedTab = 0 // Tracks the selected tab
    
    init() {
        // Customize the tab bar appearance (iOS 15+)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // Makes tab bar translucent
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial) // Glass-like blur effect
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemTeal
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MainView() // The main calorie/macros screen
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Track")
                }
                .tag(0)

            ProgressView() // Placeholder for future long-term progress
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
                .tag(1)

            SettingsView() // Placeholder for future settings page
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.teal) // Set the active tab color to teal
    }
}

#Preview {
    TrackerView()
}
