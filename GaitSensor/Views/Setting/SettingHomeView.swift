import SwiftUI

struct SettingHomeView: View {
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    
    var body: some View {
        List {
            Section {
                // 設定画面
                NavigationLink {
                    SettingView()
                } label: {
                    HStack {
                        Image(systemName: "person").icon()
                        Text("プロフィール")
                        if weight == "" {
                            (Text(Image(systemName: "exclamationmark.circle")) + Text("体重が未設定")).foregroundColor(Color.orange)
                        }
                    }
                }
                
                // 設定画面
                NavigationLink {
                    SettingDeveloperView()
                } label: {
                    HStack {
                        Image(systemName: "gearshape").icon()
                        Text("医療者向け設定")
                    }
                }
            }
            .navigationBarTitle(Text("設定"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        }.bgColor()
    }
}

struct SettingHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingHomeView()
    }
}
