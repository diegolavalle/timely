import Foundation

extension TimeInterval {

  static let secondsInHour = 3600.0
  static let secondsInMinute = 60.0
  static let minutesInHour = 60.0

  var hoursOnly: Int {
    Int(self / Self.secondsInHour)
  }

  var minutesOnly: Int {
    Int(self / Self.secondsInMinute) - hoursOnly * Int(Self.minutesInHour)
  }

  var secondsOnly: Int {
    Int(self) - hoursOnly * Int(Self.secondsInHour) - minutesOnly * Int(Self.secondsInMinute)
  }

  var formattedSummary: String {
    if hoursOnly > 0 {
      return String(format: "%02d:%02d:%02d", hoursOnly, minutesOnly, secondsOnly)
    } else {
      return String(format: "%02d:%02d", minutesOnly, secondsOnly)
    }
  }

  var formatted: String {
    let secondsAsDouble = (self * 10).rounded(.up) / 10 - Double(hoursOnly) * Self.secondsInHour - Double(minutesOnly) * Self.secondsInMinute

    if hoursOnly > 0 || minutesOnly > 0 || self == 0 {
      return formattedSummary
    } else {
      return String(format: "%02d:%04.1f", minutesOnly, secondsAsDouble)
    }
  }

  var inSecondsRounded: Int {
    Int(rounded(.up))
  }

  var formattedSeconds: String {
    String(format: "%d", inSecondsRounded)
  }
}
