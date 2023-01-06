import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            NavigationStack {
                GaitHomeView()
            }.style().tabItem {
                Image(systemName: "figure.walk")
                Text("運動")
            }
            
            NavigationStack {
                ResultHomeView()
            }.style().tabItem {
                Image(systemName: "chart.bar")
                Text("アクティビティ")
            }
            
            NavigationStack {
                SettingHomeView()
            }.style().tabItem {
                Image(systemName: "gearshape")
                Text("設定")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
