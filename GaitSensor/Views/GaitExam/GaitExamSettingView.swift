import SwiftUI

struct GaitExamSettingView: View {
    let userId: String
    let examTypeId: Int
    let examSpeedTypeId: Int
    @AppStorage(wrappedValue: 10,  "examMeter") private var meter: Int
    @State var isSelectedButton = false
    
    var body: some View {
        VStack {
            if examSpeedTypeId == 0 {
                Text("最大速度歩行").title()
                Text("可能な限り速いペースで歩いてください。\n転倒には十分に留意してください。").explain()
            }
            if examSpeedTypeId == 1 {
                Text("快適速度歩行").title()
                Text("いつものペースで歩いてください。\n転倒には十分に留意してください。").explain()
            }
        }.padding()
        

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
                Text("検査開始").button()
            }
            .primary()
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
