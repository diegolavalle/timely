import Foundation
import Combine

class TimelyStore: ObservableObject {

  @Published var showDashboard = false
  @Published var showOverlay = false
  @Published var timer: ChessTimer!

  @Published var recents: [TimerConfiguration] = {
    let key = "recents"
    if let json = UserDefaults.standard.string(forKey: key) {
      return try! JSONDecoder().decode([TimerConfiguration].self, from: json.data(using: .utf8)!)
    } else {
      let newValue = [TimerConfiguration]()
      let data = try! JSONEncoder().encode(newValue)
      let json = String(data: data, encoding: .utf8)!
      UserDefaults.standard.setValue(json, forKey: key)
      return newValue
    }
  }() {
    didSet {
      let key = "recents"
      if recents.count > 5 {
        recents.removeLast(recents.count - 5)
      }
      let jsonData = try! JSONEncoder().encode(recents)
      let json = String(data: jsonData, encoding: .utf8)!
      UserDefaults.standard.setValue(json, forKey: key)
    }
  }

  @Published var timers: [TimerConfiguration] = [
    .init(name: "Bullet 1|0", time: 60),
    .init(name: "Bullet 2|1", time: 120, delay: 1, delayType: .fischer),
    .init(name: "Blitz 3|0", time: 180),
    .init(name: "Blitz 3|2", time: 180, delay: 2, delayType: .fischer),
    .init(name: "Blitz 5|0", time: 300),
    .init(name: "Blitz 5|3", time: 300, delay: 3, delayType: .fischer),
    .init(name: "Rapid 10|0", time: 600),
    .init(name: "Rapid 10|5", time: 600, delay: 5, delayType: .bronstein),
    .init(name: "Rapid 15|10", time: 900, delay: 10, delayType: .bronstein),
    .init(name: "Classical 30|0", time: 1800),
    .init(name: "Classical 15|10", time: 1800, delay: 20, delayType: .bronstein)
  ]

  init() {
    timer = ChessTimer(recents.count > 0 ? recents[0] : .default)
  }

  func setTimer(_ config: TimerConfiguration) {
    var recents = self.recents
    if let i = recents.firstIndex(where: { $0.id == config.id }) {
      recents.remove(at: i)
    }
    recents.insert(config, at: 0)
    self.recents = recents
    timer = ChessTimer(config)
    showDashboard.toggle()
  }
}
