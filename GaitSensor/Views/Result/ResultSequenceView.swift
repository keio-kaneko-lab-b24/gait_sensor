import SwiftUI
import Charts

struct ResultSequenceView: View {
    let gaits: [Gait]
    var examTypeId: Int
    var showEnergy: Bool = false
    @State var isSelectedButton = false
    
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
            
            if showEnergy {
                // 歩数
                VStack {
                    VStack {
                        Text("歩数").title2()
                        Text("何歩歩いたか").explain()
                        Chart(gaitsSorted.suffix(7)) { gait in
                            BarMark (
                                x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                                y: .value("歩数", Double(gait.gait_steps))
                            )
                            .foregroundStyle(Color.pink.opacity(0.85))
                            .cornerRadius(10)
                        }.frame(height: 180)
                    }.padding()
                }.card()
                
                // 消費エネルギー
                VStack {
                    VStack {
                        Text("消費エネルギー").title2()
                        Text("何kcal消費したか（kcal）").explain()
                        Chart(gaitsSorted.suffix(7)) { gait in
                            BarMark (
                                x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                                y: .value("消費エネルギー", Double(gait.gait_energy))
                            )
                            .foregroundStyle(Color.pink.opacity(0.85))
                            .cornerRadius(10)
                        }.frame(height: 180)
                    }.padding()
                }.card()
            }
            
            // 歩行速度
            VStack {
                VStack {
                    Text("歩行速度").title2()
                    Text("1分あたりに何mの速度で歩いたか（m/分）").explain()
                    Chart(gaitsSorted.suffix(7)) { gait in
                        BarMark (
                            x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                            y: .value("歩行速度", Double(gait.gait_speed) * 60)
                        )
                        .foregroundStyle(Color.pink.opacity(0.85))
                        .cornerRadius(10)
                    }.frame(height: 180)
                }.padding()
            }.card()
            
            // 歩幅
            VStack {
                VStack {
                    Text("歩幅").title2()
                    Text("1歩あたりの歩幅は何mか（m）").explain()
                    Chart(gaitsSorted.suffix(7)) { gait in
                        BarMark (
                            x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                            y: .value("歩幅", Double(gait.gait_stride))
                        )
                        .foregroundStyle(Color.pink.opacity(0.85))
                        .cornerRadius(10)
                    }.frame(height: 180)
                }.padding()
            }.card()
            
            // 歩行率
            VStack {
                VStack {
                    Text("歩行率").title2()
                    Text("1分あたり何歩のペースで歩いたか（歩/分）").explain()
                    Chart(gaitsSorted.suffix(7)) { gait in
                        BarMark (
                            x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                            y: .value("歩幅", 60 * Double(gait.gait_steps) / ((Double(gait.gait_period) / 1000)))
                        )
                        .foregroundStyle(Color.pink.opacity(0.85))
                        .cornerRadius(10)
                    }.frame(height: 180)
                }.padding()
            }.card()
        }
        .bgColor()
        .toolbar {
            ToolbarItem {
                Button {
                    isSelectedButton.toggle()
                } label: {
                    HStack{
                        Text("日時で表示").toolbar()
                    }
                }
            }
        }
        
        NavigationLink(
            destination: ResultSequenceDailyView(
                gaits: gaits, examTypeId: examTypeId, showEnergy: showEnergy),
            isActive: $isSelectedButton) { EmptyView() }
    }
    
    func idString(gait: Gait, gaits: [Gait]) -> String {
        if gaits.last == gait {
            return "ID \(gait.exam_id)\n(最新)"
        }
        return "ID \(gait.exam_id)"
    }
}

struct ResultSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        ResultSequenceView(gaits: [], examTypeId: 0)
    }
}
