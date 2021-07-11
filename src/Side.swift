enum Side: String {
  case whites, blacks

  var counterPart: Self {
    self == .whites ? .blacks : .whites
  }

  mutating func toggle() {
    self = counterPart
  }
}

extension Side: CustomStringConvertible {
  var description: String {
    rawValue.capitalized
  }
}
