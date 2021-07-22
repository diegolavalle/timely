import SwiftUI

@main
struct TimelyApp: App {

  @StateObject var store = TimelyStore()

  var body: some Scene {
    WindowGroup {
      ZStack {
        TimerScreen(timer: store.timer, dashboardToggle: $store.showDashboard)
        .opacity(store.showDashboard ? 0 : 1) // To hide during transition animation

        if store.showDashboard {
          Dashboard()
          .environmentObject(store)
        }
      }
    }
  }
}
