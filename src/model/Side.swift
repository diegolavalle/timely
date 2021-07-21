enum Side: Int, CaseIterable, Identifiable, Codable {
  case whites, blacks

  static let `default` = Side(rawValue: 0)!

  var id: Int {
    rawValue
  }
  
  var counterPart: Self {
    Side(rawValue: (rawValue + 1) % Self.allCases.count)!
  }

  mutating func toggle() {
    self = counterPart
  }
}

extension Side: CustomStringConvertible {
  var description: String {
    self == .whites ? "⚪️" : "⚫️"
  }
}
