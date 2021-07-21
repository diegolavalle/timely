import SwiftUI

@main
struct TimelyApp: App {

  @StateObject var store = TimelyStore()

  var body: some Scene {
    WindowGroup {
      ZStack {
        TimerScreen(timer: store.timer, dashboardToggle: $store.showDashboard)

        if store.showDashboard {
          Dashboard()
          .environmentObject(store)
        }
      }
    }
  }
}
