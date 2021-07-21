import SwiftUI

struct ConfigBox: View {

  let config: TimerConfiguration
  @Binding var timer: ChessTimer
  @Binding var dashboardToggle: Bool

  var body: some View {
    VStack(spacing: 8) {
      VStack {
        if let name = config.name {
          Text(name).bold()
        }
        Label(config.time.formattedSummary, systemImage: config.hourglass ? "hourglass" : config.time == 0 ? "scope" : "clock")
        HStack(alignment: .firstTextBaseline) {
          if config.side != .default {
            Image(systemName: "square.lefthalf.fill")
          }
          Label(config.delay.formattedSeconds, systemImage: "arrow.counterclockwise")
          if config.delayType == .bronstein {
            Image(systemName: "b.circle")
          }
          if config.delayType == .fischer {
            Image(systemName: "f.circle")
          }
          if config.delayFirstMove {
            Image(systemName: "1.square")
          }
        }
      }
      HStack {
        /*
        Button {
        } label: {
          Label("Edit", systemImage: "pencil.circle.fill")
        }
        */
        Button {
          timer = ChessTimer(config)
          dashboardToggle.toggle()
        } label: {
          Label("Set", systemImage: "play.circle.fill")
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color("BoxBackground").opacity(0.20))
    .clipShape(RoundedRectangle(cornerRadius: 15.0))
  }
}

struct ConfigBox_Previews: PreviewProvider {
  static let configs = [
    TimerConfiguration(time: 0),
    TimerConfiguration(time: 1),
    TimerConfiguration(time: 61),
    TimerConfiguration(time: 3661),
    TimerConfiguration(side: .blacks, time: 300),
    TimerConfiguration(time: 300, delay: 3),
    TimerConfiguration(time: 300, delay: 3, delayType: .bronstein),
    TimerConfiguration(time: 300, delay: 3, delayType: .fischer, delayFirstMove: true),
    TimerConfiguration(side: .blacks, time: 300, delay: 3, delayType: .bronstein, delayFirstMove: true),
  ]

  static var previews: some View {
    Group {
      ForEach(configs) {
        ConfigBox(config: $0, timer: .constant(ChessTimer(.default)), dashboardToggle: .constant(true))
        .frame(maxWidth: 155)
      }
    }
    .previewLayout(.sizeThatFits)
  }
}
