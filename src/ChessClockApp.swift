import SwiftUI

@main
struct ChessClockApp: App {

  @StateObject var store = ChessClockStore()

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
