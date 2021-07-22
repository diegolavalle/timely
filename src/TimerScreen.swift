import SwiftUI

struct TimerScreen: View {

  @ObservedObject var timer: ChessTimer
  @Binding var dashboardToggle: Bool
  @State var overlayToggle = false
  @State var showInfo = true
  @State var showHelp = false

  var state: TimerState {
    timer.state
  }

  var status: TimerStatus {
    state.status
  }

  var body: some View {
    ZStack {
      gestureArea
      displaysBody
      optionsOverlay
    }
    .statusBar(hidden: overlayToggle ? false : true)
    .ignoresSafeArea(.container, edges: .top)
  }

  var displaysBody: some View {
    GeometryReader { p in
      LazyVGrid(
        columns: [GridItem(.adaptive(minimum: getAdaptiveMinWidth(p)), spacing: 0)],
        alignment: .leading,
        spacing: 0
      ) {
        SideDisplay(state: timer.state, side: timer.config.side.counterPart, showInfo: showInfo)
        .frame(height: getHeight(p, active: !state.firstMoversTurn))
        .rotationEffect(isPortrait(p) ? .radians(.pi) : .radians(2 * .pi))
        // … : .radians(2 * .pi) better than .zero for rotating clockwise.
        // TODO: replace with … : .zero when in reverse landscape (rotated counter-clockwise)
        .offset(isPortrait(p) ? .zero : .init(width: p.size.width / 2, height: 0))

        SideDisplay(state: timer.state, side: timer.config.side, showInfo: showInfo)
        .frame(height: getHeight(p, active: state.firstMoversTurn))
        .offset(isPortrait(p) ? .zero : .init(width: -p.size.width / 2, height: 0))
      }
      .animation(.default)
      .allowsHitTesting(false)
    }
  }

  private func isPortrait(_ p: GeometryProxy) -> Bool {
    p.size.width < p.size.height
  }

  private func getAdaptiveMinWidth(_ p: GeometryProxy) -> CGFloat {
    isPortrait(p) ? p.size.width / 2 + 1: p.size.width / 2
  }

  private func getHeight(_ p: GeometryProxy, active: Bool) -> CGFloat {
    let baseHeight = isPortrait(p) ? (p.size.height / 2) : p.size.height
    let multiplier: CGFloat
    if active && status == .active {
      multiplier = 1.25
    } else if !active && status == .active {
      multiplier = 0.75
    } else {
      multiplier = 1
    }
    return isPortrait(p) ? baseHeight * multiplier : baseHeight
  }

  var optionsOverlay: some View {
    ZStack {
      Color(.systemBackground).opacity(0.75)
      if showHelp {
        helpBody
      } else {
        VStack {
          Spacer()

          VStack(alignment: .leading, spacing: 8) {

            Button {
              withAnimation {
                overlayToggle.toggle()
              }
            } label: {
              Label("Back to clock", systemImage: "chevron.backward.circle.fill")
            }

            if status == .paused {
              Button {
                timer.start()
                withAnimation {
                  overlayToggle.toggle()
                }
              } label: {
                Label("Resume immediately", systemImage: "play.circle.fill")
              }
            }

            if status == .paused || status == .expired {
              Button {
                timer.reset()
                withAnimation {
                  overlayToggle.toggle()
                }
              } label: {
                Label("Reset clock", systemImage: "arrowshape.turn.up.backward.circle.fill")
              }
            }

            Toggle(isOn: $showInfo) {
              Label("Additional info", systemImage: "info.circle.fill")
            }

            Button {
              withAnimation {
                showHelp.toggle()
              }
            } label: {
              Label("Quick help", systemImage: "questionmark.circle.fill")
            }

            Button {
              overlayToggle.toggle()
              dashboardToggle.toggle()
            } label: {
              Label("Main dashboard", systemImage: "house.circle.fill")
            }
          }
          .font(.title)
          .foregroundColor(.primary)
          .padding()
          Spacer()
        }
        .transition(.scale)
      }
    }
    .opacity(overlayToggle ? 1 : 0)
  }

  var helpBody: some View {
    VStack(alignment: .leading, spacing: 16) {
      Spacer()
      HStack {
        Text("Quick Help: Gestures")
        Spacer()
        Button {
          withAnimation {
            showHelp.toggle()
          }
        } label: {
          Label("Back", systemImage: "chevron.backward.circle.fill")
        }
      }
      .font(.title)

      Group {
        Text("Double-tap").bold() + Text(" - While on the clock, use on any part of the screen to start the game, end your turn or resume after pause. This gesture also resets the clock after it expires.")
        Text("Tap").bold() + Text(" - Single tap toggles between \"zen\" mode and displaying additional info such as total moves. This includes helpful messages while zen mode shows the remaining times only.")
        Text("Tap and hold").bold() + Text(" - Pauses the clock and brigns up the options menu. From there you can also go back to the main dashboard. You'll be able to return from the dashboard keeping the clock's state.")
      }
      Spacer()
    }
    .padding()
    .transition(.scale)
  }

  var gestureArea: some View {
    Color(.systemBackground)
    .onTapGesture(count: 2) {
      guard status != .expired else {
        timer.reset()
        return
      }
      if status == .active {
        timer.move()
      } else {
        timer.start()
      }
    }
    .onTapGesture {
      withAnimation {
        showInfo.toggle()
      }
    }
    .onLongPressGesture(minimumDuration: 0.1) {
      if status == .active {
        timer.pause()
      }
      withAnimation {
        overlayToggle.toggle()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TimerScreen(timer: .init(.init(time: 60)), dashboardToggle: .constant(false))
  }
}
