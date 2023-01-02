import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
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
