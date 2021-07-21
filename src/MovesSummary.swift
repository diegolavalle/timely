import SwiftUI

struct MovesSummary: View {

  let state: TimerState
  let firstMover: Bool
  let moving: Bool

  var playerTotalMoves: String {
    "\((state.moves + (firstMover ? 1 : 0)) / 2)"
  }

  var playerCurrentMove: String {
    "\((state.moves + 1) / 2 + (firstMover ? 1 : 0))"
  }

  var totalMoves: String {
    "\(state.moves)"
  }

  var currentMove: String {
    "\(state.moves + 1)"
  }

  var body: some View {
    Group {
      Label(moving && state.status != .ready && state.status != .expired ? playerCurrentMove : playerTotalMoves, systemImage: "hand.draw")
      .fixedSize()
      Label(state.status == .ready || state.status == .expired ? totalMoves : currentMove, systemImage: "number.circle")
      .fixedSize()
    }
  }
}

struct MovesSummary_Previews: PreviewProvider {
  static let states = [
    TimerState(TimerConfiguration(time: 0)),
  ]

  static var previews: some View {
    Group {
      MovesSummary(state: states[0], firstMover: true, moving: true)
    }
    .previewLayout(.sizeThatFits)
  }
}
