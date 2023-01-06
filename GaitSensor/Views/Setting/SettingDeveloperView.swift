import SwiftUI

struct SettingDeveloperView: View {
    @AppStorage(wrappedValue: 5,  "voiceSpeed") private var voiceSpeed: Int
    @AppStorage(wrappedValue: 10,  "sensorHz") private var sensorHz: Int
    
    
    var body: some View {
        VStack {
            Text("アプリ設定").title()
            Text("アプリの設定ができます。").explain()
            
            List {
                Section {
                    HStack {
                        Picker(selection: $voiceSpeed, label: Text("音声速度")) {
                            Text("ゆっくり").tag(4)
                            Text("普通").tag(5)
                            Text("速い").tag(6)
                        }
                        .pickerStyle(.automatic)
                    }
                } header: {
                    Text("アプリ設定")
                }
                
                Section {
                    HStack {
                        Picker(selection: $sensorHz, label: Text("センサー取得頻度")) {
                            ForEach(1...10, id: \.self) {
                                Text("\(Int($0)) Hz").tag($0)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                } header: {
                    Text("高度な設定")
                }
            }
        }.bgColor()
    }
}
