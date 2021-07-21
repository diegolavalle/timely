import Foundation

struct TimerState {
  let config: TimerConfiguration
  var status = TimerStatus.ready

  var side: Side
  var moves = 0
  var timeFirstMover: TimeInterval
  var maybeTimeSecondMover: TimeInterval?
  var startingTime: TimeInterval
  var delay: TimeInterval

  init(_ config: TimerConfiguration) {
    self.config = config
    side = config.side
    let time = config.delayType == .simple || !config.delayFirstMove ? config.time : config.time + config.delay
    if config.hourglass {
      timeFirstMover = time / 2
    } else {
      timeFirstMover = time
      maybeTimeSecondMover = time
    }
    startingTime = time
    delay = config.delayType == .simple ? config.delay : 0
  }

  var timeSecondMover: TimeInterval {
    if config.hourglass {
      return config.time - timeFirstMover
    }
    guard let timeSecondMover = maybeTimeSecondMover else {
      fatalError("Non-hourglass timers require an explicit time for the second mover.")
    }
    return timeSecondMover
  }

  var winner: Side? {
    status == .expired ? side.counterPart :  .none
  }

  var activeTime: TimeInterval {
    time(for: side)
  }

  var firstMoversTurn: Bool {
    moves.isMultiple(of: 2)
  }

  func time(for side: Side) -> TimeInterval {
    side == config.side ? timeFirstMover : timeSecondMover
  }

  func firstMover(_ side: Side) -> Bool {
    side == config.side
  }

  func moving(_ side: Side) -> Bool {
    firstMover(side) && firstMoversTurn || (!firstMover(side) && !firstMoversTurn)
  }
}
