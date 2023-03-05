import SwiftUI
import Charts

struct ResultSequenceView: View {
    let gaits: [Gait]
    var examTypeId: Int
    var showEnergy: Bool = false
    @State var pickerSelection = 0
    
    var body: some View {
        let gaitsSorted = gaits.sorted(by: {$0.exam_id < $1.exam_id})
        ScrollView(.vertical) {
            
            VStack {
                if examTypeId == 0 {
                    Text("エクササイズの記録").title()
                } else if examTypeId == 1 {
                    Text("歩行機能検査の記録").title()
                }
            }.padding()
            
            Picker(selection: $pickerSelection, label: Text("Stats"))
                {
                Text("回").tag(0)
                Text("日").tag(1)
                Text("週").tag(2)
                Text("月").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            
            if pickerSelection == 0 {
                ResultSequenceEachView(
                    gaits: gaits, examTypeId: examTypeId, showEnergy: showEnergy)
            }
            if pickerSelection == 1 {
                ResultSequenceUnitView(
                    gaits: gaits, examTypeId: examTypeId,
                    unit: .day, unitText: "1日", showEnergy: showEnergy)
            }
            if pickerSelection == 2 {
                ResultSequenceUnitView(
                    gaits: gaits, examTypeId: examTypeId,
                    unit: .weekOfYear, unitText: "1週間", showEnergy: showEnergy)
            }
            if pickerSelection == 3 {
                ResultSequenceUnitView(
                    gaits: gaits, examTypeId: examTypeId,
                    unit: .month, unitText: "1ヶ月", showEnergy: showEnergy)
            }
        }
        .bgColor().toolbar(.hidden, for: .tabBar)

    }
}

struct ResultSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        ResultSequenceView(gaits: [], examTypeId: 0)
    }
}

