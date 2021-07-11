import Foundation

struct TimerState {
  var status = TimerStatus.ready
  var timeRemaining: (TimeInterval, TimeInterval)
  var side: Side
  var moves = 0

  init(_ config: TimerConfiguration) {
    timeRemaining = (config.time, config.time)
    side = config.side
  }

  var winner: Side? {
    status == .expired ? side.counterPart :  .none
  }
}
