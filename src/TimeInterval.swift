import Foundation

extension TimeInterval {

  static let secondsInHour = 3600.0
  static let secondsInMinute = 60.0
  static let minutesInHour = 60.0

  var formatted: String {
    let hours = Int(self / Self.secondsInHour)
    let minutes = Int(self / Self.secondsInMinute) - hours * Int(Self.minutesInHour)
    let seconds = Int(self) - hours * Int(Self.secondsInHour) - minutes * Int(Self.secondsInMinute)
    let secondsAsDouble = self - Double(hours) * Self.secondsInHour - Double(minutes) * Self.secondsInMinute

    if hours > 0 {
      return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    } else if minutes > 0 || self == 0 {
      return String(format: "%02d:%02d", minutes, seconds)
    } else {
      return String(format: "%02d:%04.1f", minutes, secondsAsDouble)
    }
  }
}
