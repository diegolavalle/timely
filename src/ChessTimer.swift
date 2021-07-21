import Foundation
import Combine

class ChessTimer: ObservableObject {

  @Published var state: TimerState

  private let timer = Timer.publish(every: 0.1, on: .main, in: .common)
  private var cancellable: Cancellable?
  private var lastTimestamp = TimeInterval?.none

  init(_ config: TimerConfiguration) {
    state = .init(config)
  }

  var config: TimerConfiguration {
    state.config
  }

  func move() {
    processTick(Date())
    state.moves += 1

    // Simple delay (US delay) implementation
    if config.delayType == .simple {
      state.delay = config.delay
    }

    // For Bronstein implementation
    let timeConsumed = state.startingTime - state.activeTime

    let incrementAfter: TimeInterval
    if config.delayType == .bronstein {
      // Bronstein implementation
      incrementAfter = min(config.delay, timeConsumed)
    } else if config.delayType == .fischer {
      incrementAfter = config.delay
    } else {
      incrementAfter = 0
    }

    if state.side == config.side {
      state.timeFirstMover += incrementAfter
    } else {
      state.maybeTimeSecondMover? += incrementAfter
    }

    state.side.toggle()

    // For Bronstein implementation (continued)
    state.startingTime = state.activeTime
  }

  func start() {
    cancellable = timer.autoconnect().sink(receiveValue: processTick)
    state.status = .active
  }

  func reset() {
    guard state.status != .active else {
      return
    }
    // No need to reset cancel/reset since we are not active at this point
    state = .init(config)
  }

  func pause() {
    state.status = .paused
    cancelTimer()
    // No need for `timer = Self.defaultTimer` as we can reconnect the cancelled one
  }

  private func cancelTimer() {
    cancellable?.cancel()
    lastTimestamp = .none
  }

  private func processTick(_ time: Date) {
    let newTimeInterval = time.timeIntervalSinceReferenceDate

    guard let previousLastTime = lastTimestamp else {
      lastTimestamp = newTimeInterval
      return
    }

    let increment = newTimeInterval - previousLastTime
    let incrementAfterDelay: TimeInterval

    let initialDelayRemaining = state.delay
    if initialDelayRemaining > 0 {
      let newDelayRemaining = initialDelayRemaining - increment
      state.delay = newDelayRemaining > 0 ? newDelayRemaining : 0
      incrementAfterDelay = newDelayRemaining < 0 ? -newDelayRemaining : 0
    } else {
      incrementAfterDelay = 0
    }

    let applicableIncrement = initialDelayRemaining > 0 ? incrementAfterDelay : increment
    if applicableIncrement > 0 {
      if config.hourglass && state.side != config.side {
        let newTimeRemaining = state.timeFirstMover + applicableIncrement
        state.timeFirstMover = newTimeRemaining < config.time ? newTimeRemaining : config.time
      } else {
        let newTimeRemaining = state.activeTime - applicableIncrement
        let adjustedTimeRemaining = newTimeRemaining > 0 ? newTimeRemaining : 0

        if state.side == config.side {
          state.timeFirstMover = adjustedTimeRemaining
        } else {
          state.maybeTimeSecondMover = adjustedTimeRemaining
        }
      }
    }

    if state.activeTime == 0 && state.delay == 0 {
      cancelTimer()
      state.status = .expired
    } else {
      lastTimestamp = newTimeInterval
    }
  }
}

enum TimerStatus {
  case ready, active, paused, expired
}
