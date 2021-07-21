import SwiftUI

struct ConfigForm: View {

  let id: UUID?
  @State var name: String
  @State var side: Side
  @State var hours: Int
  @State var minutes: Int
  @State var seconds: Int
  @State var hourglass: Bool
  @State var suddenDeath: Bool
  @State var delay: Int
  @State var delayType: TimerConfiguration.DelayType
  @State var delayFirstMove: Bool

  @EnvironmentObject var store: ChessClockStore
  @Environment(\.presentationMode) var presentationMode

  init(_ existingConfig: TimerConfiguration) {
    id = existingConfig.id
    _name = State(initialValue: existingConfig.name ?? "")
    _side = State(initialValue: existingConfig.side)
    _hours = State(initialValue: 0)
    _minutes = State(initialValue: 0)
    _seconds = State(initialValue: 0)
    _hourglass = State(initialValue: existingConfig.hourglass)
    _suddenDeath = State(initialValue: existingConfig.suddenDeath)
    _delay = State(initialValue: 0)
    _delayType = State(initialValue: existingConfig.delayType)
    _delayFirstMove = State(initialValue: false)
  }

  init() {
    id = .none
    _name = State(initialValue: "")
    _side = State(initialValue: .default)
    _hours = State(initialValue: 0)
    _minutes = State(initialValue: 5)
    _seconds = State(initialValue: 0)
    _hourglass = State(initialValue: false)
    _suddenDeath = State(initialValue: false)
    _delay = State(initialValue: 0)
    _delayType = State(initialValue: .simple)
    _delayFirstMove = State(initialValue: false)
  }

  var time: TimeInterval {
    TimeInterval(hours * 3600 + minutes * 60 + seconds)
  }

  var validInfo: Bool {
    name.count < 100 &&
    // Name cannot be longer than 100 characters
    (time > 0 || delay > 0) &&
    // Either time or delay must be greater than zero
    (delayType != .simple && delay > 0 || delayType == .simple) &&
    // Delay cannot be zero for Bronstein and Fischer delay types
    (delayType == .simple && !delayFirstMove || delayType != .simple) &&
    // Delay first move is only applicable to Bronstein and Fischer delay types
    (!hourglass || time > 0 && delayType == .simple)
    // Hourglass mode requires non-zero time and only supports simple delay
  }

  var body: some View {
    Form {
      Section {
        TextField("Timer name", text: $name)
      }
      Section(header: Label("Starting side", systemImage: "square.and.line.vertical.and.square"), footer: Text("Use this field to select an alternative starting side.")) {
        Picker(selection: $side, label: Label("First mover", systemImage: "square.lefthalf")) {
          ForEach(Side.allCases) {
            Text("\($0.description)").tag($0)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      Section(header: Label("Time", systemImage: "clock")) {
        Group {
          Stepper("\(hours)h", value: $hours, in: 0 ... 35)
          Stepper("\(minutes)'", value: $minutes, in: 0 ... 60)
          Stepper("\(seconds)''", value: $seconds, in: 0 ... 60)
        }
        .disabled(suddenDeath)
      }
      Section(header: Label("Hourglass", systemImage: "hourglass"), footer: Text("All time consumed is automatically added to the rival side in realtime.")) {
        Toggle("Hourglass mode", isOn: $hourglass)
        .disabled(suddenDeath)
      }
      Section(header: Label("Sudden death", systemImage: "scope"), footer: Text("Each turn the player gets the full amount of seconds specified in the delay field. If a player runs out of time during a turn, they lose the game.")) {
        Toggle("Sudden death", isOn: $suddenDeath)
        .disabled(hourglass)
      }
      Section(header: Label("Delay", systemImage: "timer")) {
        Stepper("\(delay)''", value: $delay, in: 0 ... 60)
        Picker(selection: $delayType, label: Text("Delay Type")) {
          ForEach(TimerConfiguration.DelayType.allCases) {
            Text("\($0.name)").tag($0)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .disabled(hourglass || suddenDeath)
        Toggle("Apply delay to first move", isOn: $delayFirstMove)
        .disabled(delayType != .bronstein && delayType != .fischer)
      }
      Button {
        let name: String? = name == "" ? .none : name
        let delay = TimeInterval(delay)
        let config = TimerConfiguration(name: name, side: side, time: time, hourglass: hourglass, delay: delay, delayType: delayType, delayFirstMove: delayFirstMove)
        store.setTimer(config)
        presentationMode.wrappedValue.dismiss()
      } label: {
        Label("Set timer", systemImage: "play.circle.fill")
      }
      .disabled(!validInfo)
    }
    .onChange(of: hourglass) {
      if $0 {
        suddenDeath = false
        delayType = .simple
      }
    }
    .onChange(of: suddenDeath) {
      if $0 {
        hours = 0
        minutes = 0
        seconds = 0
        hourglass = false
        delayType = .simple
        if delay == 0 {
          delay = 5
        }
      }
    }
    .onChange(of: delayType) {
      if $0 == .simple {
        delayFirstMove = false
      }
    }
    .onChange(of: hours, perform: handleTimeChange)
    .onChange(of: minutes, perform: handleTimeChange)
    .onChange(of: seconds, perform: handleTimeChange)
  }

  func handleTimeChange(value: Int) {
    if time == 0 {
      suddenDeath = true
    }
  }
}

struct ConfigForm_Previews: PreviewProvider {
  static var previews: some View {
    ConfigForm()
  }
}
