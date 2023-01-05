import SwiftUI

struct SettingView: View {
    @AppStorage(wrappedValue: "",  "gender") private var gender: String
    @AppStorage(wrappedValue: "",  "age") private var age: String
    @AppStorage(wrappedValue: "",  "height") private var height: String
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    @AppStorage(wrappedValue: 5,  "voiceSpeed") private var voiceSpeed: Int
    @AppStorage(wrappedValue: 10,  "sensorHz") private var sensorHz: Int
    
    
    var body: some View {
        VStack {
            Text("登録情報").title()
            Text("登録情報の編集ができます。\n体重は消費エネルギーの計算に使用されます。").explain()

            List {
                Section {
                    HStack {
                        Picker(selection: $gender, label: Text("性別")) {
                            Text("-").tag("-")
                            Text("男性").tag("男性")
                            Text("女性").tag("女性")
                            Text("どちらでもない").tag("どちらでもない")
                        }
                        .pickerStyle(.automatic)
                    }
                    
                    HStack {
                        Text("年齢")
                        Spacer()
                        TextField("年齢を入力してください", text: $age).keyboardType(.decimalPad).multilineTextAlignment(TextAlignment.trailing)
                        Text("歳")
                    }
                    
                    HStack {
                        Text("身長")
                        Spacer()
                        TextField("身長を入力してください", text: $height).keyboardType(.decimalPad).multilineTextAlignment(TextAlignment.trailing)
                        Text("cm")
                    }
                    
                    HStack {
                        Text("体重")
                        Spacer()
                        TextField("体重を入力してください", text: $weight).keyboardType(.decimalPad).multilineTextAlignment(TextAlignment.trailing)
                        Text("kg")
                    }
                } header: {
                    Text("登録情報")
                }
                
                Section {
                    HStack {
                        Picker(selection: $voiceSpeed, label: Text("音声速度")) {
                            Text("ゆっくり").tag(4)
                            Text("普通").tag(5)
                            Text("速い").tag(6)
                        }
                        .pickerStyle(.automatic)
                    }
                    
                    HStack {
                        Picker(selection: $sensorHz, label: Text("センサー取得頻度")) {
                            ForEach(1...10, id: \.self) {
                                Text("\(Int($0)) Hz").tag($0)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                } header: {
                    Text("アプリ設定")
                }
            }
        }
    }
}
