import SwiftUI

struct SettingDeveloperView: View {
    @AppStorage(wrappedValue: 10,  "sensorHz") private var sensorHz: Int
    
    
    var body: some View {
        VStack {
            Text("医療者向け設定").title()
            Text("センサーについての高度な設定が可能です。").explain()
              
            List {
                Section {
                    HStack {
                        Picker(selection: $sensorHz, label: Text("センサー取得頻度")) {
                            ForEach(1...10, id: \.self) {
                                Text("\(Int($0)) Hz").tag($0)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                }
            }
        }.bgColor()
    }
}
