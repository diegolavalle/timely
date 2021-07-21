import Foundation

struct TimerConfiguration: Identifiable, Codable {
  let id: UUID
  let name: String?
  let side: Side
  let time: TimeInterval
  let hourglass: Bool
  let delay: TimeInterval
  let delayType: DelayType
  let delayFirstMove: Bool

  static let `default` = TimerConfiguration(name: "Default timer", time: 300)

  init(name: String? = .none, side: Side = .default, time: TimeInterval, hourglass: Bool = false, delay: TimeInterval = 0, delayType: DelayType = .simple, delayFirstMove: Bool = false) {
    precondition(
      name?.count ?? 0 < 100,
      "Name cannot be longer than 100 characters."
    )
    precondition(
      time > 0 || delay > 0,
      "Either time or delay must be greater than zero."
    )
    precondition(
      delayType != .simple && delay > 0 || delayType == .simple,
      "Delay cannot be zero for Bronstein and Fischer delay types."
    )
    precondition(
      delayType == .simple && !delayFirstMove || delayType != .simple,
      "Delay first move is only applicable to Bronstein and Fischer delay types."
    )
    precondition(
      !hourglass || time > 0 && delayType == .simple,
      "Hourglass mode requires non-zero time and only supports simple delay."
    )
    self.id = UUID()
    self.name = name
    self.time = time
    self.hourglass = hourglass
    self.side = side
    self.delay = delay
    self.delayType = delayType
    self.delayFirstMove = delayFirstMove
  }

  var suddenDeath: Bool {
    time == 0
  }
}

extension TimerConfiguration {

  enum DelayType: Int, CaseIterable, Identifiable, Codable {

    case simple, bronstein, fischer

    var id: Int {
      rawValue
    }

    var letter: String {
      switch self {
      case .simple:
        return ""
      case .bronstein:
        return "B"
      case .fischer:
        return "F"
      }
    }

    var name: String {
      switch self {
      case .simple:
        return "Simple Delay"
      case .bronstein:
        return "Bronstein"
      case .fischer:
        return "Fischer"
      }
    }
  }
}
