import SwiftUI

struct TimerScreen: View {

  @Binding var mainMenuToggle: Bool
  @StateObject var timer = ChessTimer(.init(time: 15))
  @State var forceShowOverlay = false

  var showOverlay: Bool {
    forceShowOverlay || status == .paused
  }

  var state: TimerState {
    timer.state
  }

  var status: TimerStatus {
    timer.state.status
  }

  var firstMoverActive: Bool {
    status != .ready && state.side == timer.config.side
  }

  var body: some View {
    ZStack {
      gestureArea

      VStack(spacing: 0) {
        SideDisplay(config: timer.config, state: timer.state, side: timer.config.side.counterPart, inverted: true)
        SideDisplay(config: timer.config, state: timer.state, side: timer.config.side)
      }
      .allowsHitTesting(false)
      .ignoresSafeArea(.container, edges: .top)

      optionsOverlay
    }
    .statusBar(hidden: showOverlay ? false : true)
  }

  var optionsOverlay: some View {
    ZStack {
      Color(.systemBackground).opacity(0.9)
      VStack {
        Spacer()

        VStack(alignment: .leading, spacing: 8) {
        
          if status == .paused {
            Button {
              timer.start()
            } label: {
              Label("Resume", systemImage: "play.circle.fill")
            }
          }

          if status == .paused || status == .expired {
            Button {
              if status == .expired {
                withAnimation {
                  forceShowOverlay.toggle()
                }
              }
              timer.reset()
            } label: {
              Label("Reset", systemImage: "arrowshape.turn.up.backward.circle.fill")
            }
          }

          if status == .ready || status == .expired {
            Button {
              withAnimation {
                forceShowOverlay.toggle()
              }
            } label: {
              Label("Back", systemImage: "chevron.backward.circle.fill")
            }
          }

          Button {
            withAnimation() {
              mainMenuToggle.toggle()
            }
          } label: {
            Label("Main Menu (Exit Timer)", systemImage: "house.circle.fill")
          }
        }
        .font(.title)
        Spacer()
      }
    }
    .ignoresSafeArea(.container, edges: .top)
    .opacity(showOverlay ? 1 : 0)
  }

  var gestureArea: some View {
    Color(.systemBackground)
    .ignoresSafeArea(.container, edges: .top)
    .onTapGesture { // .onTapGesture(count: 2) {
      guard status == .ready || status == .active else {
        return
      }

      withAnimation {
        if status == .ready {
          timer.start()
        } else {
          timer.move()
        }
      }
    }
    .onLongPressGesture(minimumDuration: 0.1) {
      if status == .active {
        timer.pause()
      } else {
        forceShowOverlay.toggle()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TimerScreen(mainMenuToggle: .constant(true))
  }
}
