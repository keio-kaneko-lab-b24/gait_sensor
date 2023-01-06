import SwiftUI

struct GaitHomeView: View {
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
                    GaitExamSettingView(userId: userId, examTypeId: 1)
                } label: {
                    HStack {
                        Image(systemName: "figure.strengthtraining.functional").icon()
                        Text("機能検査")
                    }
                }
            }
            .navigationBarTitle(Text("運動"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        }.bgColor()
    }
}

struct GaitHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GaitHomeView()
    }
}
