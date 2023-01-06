import SwiftUI

struct SettingView: View {
    @AppStorage(wrappedValue: "-",  "gender") private var gender: String
    @AppStorage(wrappedValue: NSDate() as Date,  "birthday") private var birthday: Date
    @AppStorage(wrappedValue: "",  "height") private var height: String
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    
    var body: some View {
        VStack {
            VStack {
                Text("プロフィール").title()
                Text("プロフィールの編集ができます。\n体重は消費エネルギーの計算に使用されます。").explain()
            }.padding(.top)
            
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
                        DatePicker("生年月日", selection: $birthday, in: ...Date.now, displayedComponents: .date)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
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
                }
            }
        }.bgColor()
    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
