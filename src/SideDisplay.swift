import SwiftUI

struct SideDisplay: View {
  let state: TimerState
  let side: Side
  let showInfo: Bool

  var config: TimerConfiguration {
    state.config
  }

  var status: TimerStatus {
    state.status
  }

  var moves: Int {
    state.moves
  }

  var playersTurn: Bool {
    state.moving(side)
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
    state.time(for: side)
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
      VStack(spacing: 16) {

        if moving && config.delay > 0 && state.delay > 0 {
          Text(state.delay.formattedSeconds)
          .font(Font.system(.title, design: .monospaced))
          .frame(minWidth: 40, alignment: .center)
          .padding()
          .background(Color.secondary)
          .blendMode(.overlay)
          .colorInvert()
          .transition(.scale)
        }

        if config.time > 0 || state.status == .expired {
          HStack {
            Text(config.hourglass && !playersTurn ? time.formattedSummary : time.formatted).bold()
            if status == .expired {
              Image(systemName: won ? "hands.clap.fill" : "flag.fill")
            }
          }
          .font(Font.system(state.delay > 0 ? .title3 : .title, design: .monospaced))
        }

        VStack(spacing: 8) {
          HStack(alignment: .firstTextBaseline) {
            Text(side.description)
            MovesSummary(state: state, firstMover: state.firstMover(side), moving: moving)
          }
          .font(.callout)

          ConfigSummary(config: config)
        }
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
      SideDisplay(state: timer.state, side: timer.config.side, showInfo: true)
      .frame(maxHeight: 300)
    }
    .previewLayout(.sizeThatFits)
  }
}
