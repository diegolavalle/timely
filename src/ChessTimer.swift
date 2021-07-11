import Foundation
import Combine

class ChessTimer: ObservableObject {

  @Published var config: TimerConfiguration
  @Published var state: TimerState

  private let timer = Timer.publish(every: 0.1, on: .main, in: .common)
  private var cancellable: Cancellable?
  private var lastTimestamp = TimeInterval?.none

  init(_ config: TimerConfiguration) {
    self.config = config
    state = .init(config)
  }

  func move() {
    processTick(Date())
    state.moves += 1
    state.side.toggle()
  }

  func set(_ seconds: TimeInterval) {
    config = .init(time: seconds)
    state = .init(config)
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
    let activeTimeRemaining = state.side == config.side ? state.timeRemaining.0 : state.timeRemaining.1
    let newTimeRemaining = activeTimeRemaining - increment
    let asjustedTimeRemaining = newTimeRemaining > 0 ? newTimeRemaining : 0
    
    if state.side == config.side {
      state.timeRemaining.0 = asjustedTimeRemaining
    } else {
      state.timeRemaining.1 = asjustedTimeRemaining
    }

    if asjustedTimeRemaining == 0 {
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
