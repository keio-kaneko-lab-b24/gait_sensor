import SwiftUI

struct GaitExerciseSettingView: View {
    let userId: String
    let examTypeId: Int
    @State private var minutes = 2
    @State private var seconds = 0
    @State var isSelectedButton = false
    @State var showAlert = false
    
    var body: some View {
        VStack {
            Text("ウォーキング").font(.title2).bold()
            Text("転倒には十分に留意してください\n音声ガイドを有効にするにはマナーモードを解除してください").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary).multilineTextAlignment(.center)
        }
        
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
                        isSelectedButton = true
                    }
                } ){
                    Text("ウォーキング開始").frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40).bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding()
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
