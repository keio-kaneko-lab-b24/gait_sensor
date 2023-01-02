import SwiftUI

struct GaitExerciseSettingView: View {
    let userId: String
    let examTypeId: Int
    @State private var minutes = 2
    @State private var seconds = 0
    @State var isSelectedButton = false
    @State var showAlert = false
    
    var body: some View {
        Text("歩行エクササイズ").font(.title)
        Spacer()
        Text("転倒には十分に留意してください。")
        
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
                
                Button {
                    if minutes == 0 && seconds == 0 {
                        showAlert = true
                    } else {
                        isSelectedButton = true
                    }
                } label: {
                    Text("検査開始").bold()
                }
                .alert("時間が0秒です", isPresented: $showAlert) {
                    Button("OK") { /* Do Nothing */}
                } message: {
                    Text("0分0秒以上を選択してください。")
                }
            }
        }
        
        NavigationLink(
            destination: GaitExerciseView(
                userId: userId, examTypeId: examTypeId,
                minutes: minutes, seconds: seconds),
            isActive: $isSelectedButton) { EmptyView() }
    }
}
