import Foundation

struct TimerConfiguration {
  let time: TimeInterval
  let side: Side

  init(time: TimeInterval, side: Side = .whites) {
    self.time = time
    self.side = side
  }
}
