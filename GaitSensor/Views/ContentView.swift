import SwiftUI

struct HomeView: View {
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    
    let userId: String = "User_A"
    var body: some View {
        List {
            Section {
                
                // ウォーキング画面
                NavigationLink {
                    GaitExerciseSettingView(userId: userId, examTypeId: 0)
                } label: {
                    HStack {
                        Image(systemName: "figure.walk").icon()
                        Text("ウォーキング")
                    }
                }

                // 歩行機能検査画面
                NavigationLink {
                    GaitExamSelectView(userId: userId, examTypeId: 1)
                } label: {
                    HStack {
                        Image(systemName: "figure.walk").icon()
                        Text("歩行機能検査")
                    }
                }
                
                // 結果一覧表示画面
                NavigationLink {
                    ResultSelectView()
                } label: {
                    HStack {
                        Image(systemName: "chart.bar").icon()
                        Text("結果表示")
                    }
                }
                
                // 設定画面
                NavigationLink {
                    SettingView()
                } label: {
                    HStack {
                        Image(systemName: "gearshape").icon()
                        Text("設定")
                        if weight == "" {
                            (Text(Image(systemName: "exclamationmark.circle")) + Text("体重が未設定")).foregroundColor(Color.orange)
                        }
                    }
                }
                
                // デバッグ画面
//                NavigationLink {
//                    DebugView()
//                } label: {
//                    HStack {
//                        Image(systemName: "chart.bar.doc.horizontal").icon()
//                        Text("デバッグ")
//                    }
//                }.foregroundColor(.gray)
            }
        }
        .navigationBarTitle(Text("ホーム"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}


struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }.style()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
