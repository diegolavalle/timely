import SwiftUI

struct SideDisplay: View {
  let config: TimerConfiguration
  let state: TimerState
  let side: Side
  let showInfo: Bool

  var status: TimerStatus {
    state.status
  }

  var moves: Int {
    state.moves
  }

  var firstMover: Bool {
    side == config.side
  }

  var playersTurn: Bool {
    (firstMover && moves.isMultiple(of: 2)) || (!firstMover && !moves.isMultiple(of: 2))
  }

  var actionNeeded: Bool {
    !playersTurn && (status == .ready || status == .paused)
  }

  var moving: Bool {
    playersTurn && status == .active
  }

  var lost: Bool {
    playersTurn && status == .expired
  }

  var won: Bool {
    !playersTurn && status == .expired
  }

  var time: TimeInterval {
    firstMover ? state.timeRemaining.0 : state.timeRemaining.1
  }

  var message: String? {
    if actionNeeded && status == .ready {
      return "Double-tap anywhere to start your OPPONENT'S clock. Hold for options."
    } else if actionNeeded {
      return "Double-tap anywhere to resume your OPPONENT'S clock. Hold for options."
    } else if moving {
      return "Double-tap anywhere to end your turn. Hold for pause and options."
    } else if won {
      return "You've won! Double-tap anywhere to reset. Hold for options."
    } else if lost {
      return "You've lost. Double-tap anywhere to reset. Hold for options."
    } else {
      return nil
    }
  }

  var body: some View {
    VStack {
      Spacer()
      VStack {
        Text(side.description)
        .opacity(showInfo ? 1 : 0)

        HStack {
          Text(time.formatted)
          if status == .expired {
            Image(systemName: won ? "hands.clap.fill" : "flag.fill")
          }
        }
        .font(Font.system(.title, design: .monospaced))
        Text("Total moves: \(moves)")
        .opacity(showInfo ? 1 : 0)
      }
      .padding()
      Spacer()
      if let message = message {
        VStack {
          Text(message)
          .font(.callout)
        }
        .padding()
        .opacity(showInfo ? 1 : 0)
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(actionNeeded ? Color.orange : moving || won ? Color.green : Color.gray)
    .animation(.default)
  }
}

struct SideDisplay_Previews: PreviewProvider {
  static let timer = ChessTimer(.init(time: 55))
  static var previews: some View {
    Group {
      SideDisplay(config: timer.config, state: timer.state, side: timer.config.side, showInfo: true)
    }
    .previewLayout(.sizeThatFits)
  }
}
