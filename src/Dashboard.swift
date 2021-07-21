import SwiftUI

fileprivate struct BarItemsModifier: ViewModifier {

  @EnvironmentObject var store: TimelyStore

  @State var showNew = false

  func body(content: Content) -> some View {
    content
    .navigationBarItems(
      leading: Button {
        store.showDashboard.toggle()
      } label: {
        Label("Timer", systemImage: "deskclock")
      },
      trailing: Button {
        showNew.toggle()
      } label: {
        Label("New", systemImage: "plus")
      }
      .sheet(isPresented: $showNew) {
        ConfigForm()
        .environmentObject(store)
      }
    )
  }
}

fileprivate extension View {
  func barItems() -> some View {
    self.modifier(BarItemsModifier())
  }
}

struct Dashboard: View {

  @EnvironmentObject var store: TimelyStore

  var body: some View {
    TabView(selection: .constant(0)) {

    NavigationView {
      ScrollView {
        LazyVGrid(
          columns: [.init(.adaptive(minimum: 155), spacing: 8)],
          spacing: 8
        ) {
          ForEach(store.recents) { config in
            ConfigBox(config: config, timer: $store.timer, dashboardToggle: $store.showDashboard)
          }
        }
        .padding()
      }
      .navigationTitle("Recent timers")
      .barItems()
    }
    .tabItem {
      Label("Recent", systemImage: "clock.arrow.circlepath")
    }.tag(0)

    NavigationView {
      ScrollView {
        LazyVGrid(
          columns: [.init(.adaptive(minimum: 155), spacing: 8)],
          spacing: 8
        ) {
          ForEach(store.timers) { config in
            ConfigBox(config: config, timer: $store.timer, dashboardToggle: $store.showDashboard)
          }
        }
        .padding()
      }
      .navigationTitle("Presets")
      .barItems()
    }
    .tabItem {
      Label("Presets", systemImage: "slider.horizontal.3")
    }.tag(2)

    }
    .navigationViewStyle(StackNavigationViewStyle())
    .transition(.slide)
    .animation(.default)
  }
}

struct Dashboard_Previews: PreviewProvider {
  static var previews: some View {
    Dashboard()
    .environmentObject(TimelyStore.init())
  }
}
