import SwiftUI

struct SettingView: View {
    @AppStorage(wrappedValue: "",  "age") private var age: String
    @AppStorage(wrappedValue: "",  "height") private var height: String
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    
    
    var body: some View {
        VStack {
            Text("登録情報").font(.title2).bold()
            Text("登録情報の編集ができます。\n体重は消費エネルギーの計算に使用されます。").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary).multilineTextAlignment(.center)

            List {
                HStack {
                    Text("年齢")
                    Spacer()
                    TextField("年齢を入力してください", text: $age).keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("身長")
                    Spacer()
                    TextField("身長を入力してください", text: $height).keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("体重")
                    Spacer()
                    TextField("体重を入力してください", text: $weight).keyboardType(.decimalPad)
                }
            }
        }
    }
}
