import SwiftUI
import Combine

struct Concept_TimerView: View {

  static let initialValue = 10.0
  static var defaultTimer: Timer.TimerPublisher {
    Timer.publish(every: 0.1, on: .main, in: .common)
  }

  @State var timeRemaining = Self.initialValue
  @State var lastTime = TimeInterval?.none

  @State var timer = Self.defaultTimer

  @State var cancellable: Cancellable?

  var body: some View {
    VStack {
      Text("\(timeRemaining)")
      .onReceive(timer) { time in
        let newTimeInterval = time.timeIntervalSinceReferenceDate
        defer {
          lastTime = newTimeInterval
        }
        guard let previousLastTime = lastTime else {
          return
        }
        let increment = newTimeInterval - previousLastTime
        if timeRemaining > 0 {
          timeRemaining -= increment
        }
      }
      HStack {
        Button {
          cancellable = timer.connect()
        } label: {
          Text("Start")
        }
        Button {
          timeRemaining = Self.initialValue
        } label: {
          Text("Reset")
        }
        Button {
          cancellable?.cancel()
          timer = Self.defaultTimer
          lastTime = .none
        } label: {
          Text("Stop")
        }
      }
    }
  }
}

struct Concept_TimerView_Previews: PreviewProvider {
  static var previews: some View {
    Concept_TimerView()
  }
}
