import SwiftUI

struct ConfigSummary: View {

  let config: TimerConfiguration

  var body: some View {
    VStack {
      if config.name != .none {
        HStack(alignment: .firstTextBaseline) {
          if let name = config.name {
            Text(name)
          }
          if config.side != .default {
            startingSideBody
          }
        }
      }
      HStack(alignment: .firstTextBaseline) {
        if config.side != .default && config.name == .none {
          startingSideBody
        }
        Label(config.time.formattedSummary, systemImage: config.hourglass ? "hourglass" : config.time == 0 ? "scope" : "clock")
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
    .font(.callout)
  }
  
  var startingSideBody: some View {
    Image(systemName: "square.lefthalf.fill")
  }
}

struct ConfigSummary_Previews: PreviewProvider {
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
        ConfigSummary(config: $0)
      }
    }
    .previewLayout(.sizeThatFits)
  }
}
