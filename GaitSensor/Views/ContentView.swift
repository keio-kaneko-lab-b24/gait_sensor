import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            // 結果一覧表示画面
            NavigationLink {
                ResultSelectView()
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("結果表示")
                }
            }
            
            // 設定画面
            NavigationLink {
                SettingView()
            } label: {
                HStack {
                    Image(systemName: "gearshape")
                    Text("設定")
                }
            }
            
            // デバッグ画面
            NavigationLink {
                DebugView()
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("デバッグ")
                }
            }.foregroundColor(.gray)
        }.navigationBarTitle(Text("ホーム"))
    }
}


struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
