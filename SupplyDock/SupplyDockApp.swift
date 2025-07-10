import SwiftUI

@main
struct SupplyDockApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                MarinaMapTab()
                    .tabItem { Label("Map",  systemImage: "map.fill") }
                FloatPlanListTab()                            // ← new
                       .tabItem { Label("Float Plan", systemImage: "note.text") }
            }
        }
    }
}
