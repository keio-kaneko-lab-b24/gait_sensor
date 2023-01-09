import SwiftUI

struct GaitExerciseSettingView: View {
    let userId: String
    let examTypeId: Int
    @AppStorage(wrappedValue: 2,  "exerciseMinutes") private var minutes: Int
    @AppStorage(wrappedValue: 30,  "exerciseSeconds") private var seconds: Int
    @State var isSelectedButton = false
    @State var showAlert = false
    
    var body: some View {
        VStack {
            VStack {
                Text("ウォーキング").title()
                Text("転倒には十分に留意してください。\n音声ガイドを有効にするにはマナーモードを解除してください。").explain()
            }.padding(.top)
            
            Form {
                Section {
                    Picker(selection: $minutes, label: Text("時間（分）")) {
                        ForEach(0...60, id: \.self) {
                            Text("\($0) 分").tag($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                    Picker(selection: $seconds, label: Text("時間（秒）")) {
                        ForEach(0...5, id: \.self) {
                            Text("\($0)0 秒").tag($0*10)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                } footer: {
                    Button(action: {
                        if minutes == 0 && seconds == 0 {
                            showAlert = true
                        } else {
                            isSelectedButton.toggle()
                        }
                    } ){
                        Text("ウォーキング開始").button()
                    }
                    .primary()
                    .padding()
                    .alert("時間が0秒です", isPresented: $showAlert) {
                        Button("OK") { /* Do Nothing */}
                    } message: {
                        Text("0分0秒以上を選択してください。")
                    }
                }
            }
        }.bgColor()
        
        NavigationLink(
            destination: GaitExerciseView(
                userId: userId, examTypeId: examTypeId,
                minutes: minutes, seconds: seconds),
            isActive: $isSelectedButton) { EmptyView() }
    }
}
