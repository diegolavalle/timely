import Foundation
import Combine

class ChessClockStore: ObservableObject {

  @Published var showDashboard = false
  @Published var showOverlay = false
  @Published var timer = ChessTimer(TimerConfiguration(time: 3))

  @Published var timers: [TimerConfiguration] = [
    .init(time: 60),
    .init(time: 120),
    .init(time: 180),
    .init(time: 300),
    .init(time: 600),
    .init(time: 1800),
  ]

}
