import SwiftUI

struct HomeView: View {
    let userId: String = "User_A"
    var body: some View {
        List {
            // ウォーキング画面
            NavigationLink {
                GaitExerciseSettingView(userId: userId, examTypeId: 0)
            } label: {
                HStack {
                    Image(systemName: "figure.walk")
                    Text("ウォーキング")
                }
            }

            // 歩行機能検査画面
            NavigationLink {
                GaitExamSelectView(userId: userId, examTypeId: 1)
            } label: {
                HStack {
                    Image(systemName: "figure.walk")
                    Text("歩行機能検査")
                }
            }
            
            // 結果一覧表示画面
            NavigationLink {
                ResultSelectView()
            } label: {
                HStack {
                    Image(systemName: "chart.bar.doc.horizontal")
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
                    Image(systemName: "chart.bar.doc.horizontal")
                    Text("デバッグ")
                }
            }.foregroundColor(.gray)
        }
        .navigationBarTitle(Text("ホーム"), displayMode: .automatic)
        .navigationBarBackButtonHidden(true)
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
