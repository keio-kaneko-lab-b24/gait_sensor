import SwiftUI

struct GaitExamSettingView: View {
    let userId: String
    let examTypeId: Int
    let examSpeedTypeId: Int
    @State private var meter = 10
    @State var isSelectedButton = false
    
    var body: some View {
        VStack {
            if examSpeedTypeId == 0 {
                Text("最大速度歩行").font(.title2).bold()
                Text("可能な限り速いペースで歩いてください。\n転倒には十分に留意してください。").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary).multilineTextAlignment(.center)
            }
            if examSpeedTypeId == 1 {
                Text("快適速度歩行").font(.title2).bold()
                Text("可能な限り速いペースで歩いてください。\n転倒には十分に留意してください。").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary).multilineTextAlignment(.center)
            }
        }
        

        Form {
            Section {
                Picker(selection: $meter, label: Text("歩行距離")) {
                    Text("10 m").tag(10)
                    Text("20 m").tag(20)
                    Text("30 m").tag(30)
                    Text("40 m").tag(40)
                    Text("50 m").tag(50)
                }
                .pickerStyle(.automatic)
        } footer: {
            Button(action: {
                isSelectedButton = true
            } ){
                Text("検査開始").frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40).bold()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .padding()
        }
            
        }
        NavigationLink(
            destination: GaitExamView(
                userId: userId, examTypeId: examTypeId,
                examSpeedTypeId: examSpeedTypeId, meter: meter),
            isActive: $isSelectedButton) { EmptyView() }
    }
}
