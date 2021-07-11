import SwiftUI

struct Dashboard: View {

  @EnvironmentObject var store: ChessClockStore

  var body: some View {
    NavigationView {
      LazyVGrid(
        columns: .init(repeating: .init(.flexible(minimum: 50, maximum: 150)), count: 2),
        spacing: 8
      ) {
        ForEach(store.timers, id: \.time) { timer in
          Button {
            store.timer = ChessTimer(timer)
            store.showDashboard.toggle()
          } label: {
            GroupBox {
              Text(timer.time.formatted)
            }
          }
        }
      }
      .frame(maxWidth: .infinity)
      .navigationTitle("Dashboard")
      .navigationBarItems(
        trailing: Button {
          store.showDashboard.toggle()
        } label: {
          Image(systemName: "timer")
        }
      )
    }
    .transition(.slide)
    .animation(.default)
  }
}

struct Dashboard_Previews: PreviewProvider {
  static var previews: some View {
    Dashboard()
  }
}
