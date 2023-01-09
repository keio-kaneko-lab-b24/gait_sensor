import SwiftUI

struct ContentView: View {
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    
    var body: some View {
        TabView() {
            NavigationStack {
                GaitHomeView()
            }.tabItem {
                Image(systemName: "shoeprints.fill")
                Text("運動")
            }
            
            NavigationStack {
                ResultHomeView()
            }.tabItem {
                Image(systemName: "chart.bar.fill")
                Text("記録")
            }
            
            NavigationStack {
                SettingHomeView()
            }.tabItem {
                Image(systemName: "gearshape.fill")
                Text("設定")
            }.badge(SettingBudge())
        }.style().modify()
    }
    
    /*
     セッティングのバッジ数
     */
    private func SettingBudge() -> Int {
        var budge = 0
        if weight == "" {
            budge += 1
        }
        return budge
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
