import SwiftUI
import Charts

struct ResultSequenceView: View {
    let gaits: [Gait]
    var examTypeId: Int
    
    var body: some View {
        var gaitsSorted = gaits.sorted(by: {$0.exam_id < $1.exam_id})
        ScrollView(.vertical) {
            
            VStack {
                if examTypeId == 0 {
                    Text("ウォーキングの記録").title()
                } else if examTypeId == 1 {
                    Text("歩行機能検査の記録").title()
                }
            }.padding()
            
            // 消費エネルギー
            VStack {
                Text("累計歩数").title2()
                Text("どれだけの歩数歩いたか").explain()
                HStack {
                    Text("\(totalSteps(gaits: gaitsSorted))").large()
                    Text("歩")
                }
            }.padding()
            
            // 消費エネルギー
            VStack {
                Text("累計消費エネルギー").title2()
                Text("どれだけのエネルギーを消費したか").explain()
                HStack {
                    Text("\(Int(totalCalory(gaits: gaitsSorted)))").large()
                    Text("kcal")
                }
            }.padding()
            
            // 歩行速度
            VStack {
                Text("歩行速度").title2()
                Text("1分あたりに何m歩いたか").explain()
                Chart(gaitsSorted.suffix(10)) { gait in
                    BarMark (
                        x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                        y: .value("歩行速度", Double(gait.gait_speed) * 60)
                    )
                    .foregroundStyle(Color.pink.opacity(0.85))
                    .cornerRadius(10)
                }.frame(height: 180)
            }.padding()
            
            // 歩幅
            VStack {
                Text("歩幅").title2()
                Text("1歩あたりの歩幅は何mか").explain()
                Chart(gaitsSorted.suffix(10)) { gait in
                    BarMark (
                        x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                        y: .value("歩幅", Double(gait.gait_stride))
                    )
                    .foregroundStyle(Color.pink.opacity(0.85))
                    .cornerRadius(10)
                }.frame(height: 180)
            }.padding()
            
            // 歩行率
            VStack {
                Text("歩行率").title2()
                Text("1分あたり何歩歩いたか").explain()
                Chart(gaitsSorted.suffix(10)) { gait in
                    BarMark (
                        x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                        y: .value("歩幅", 60 * Double(gait.gait_steps) / ((Double(gait.gait_period) / 1000)))
                    )
                    .foregroundStyle(Color.pink.opacity(0.85))
                    .cornerRadius(10)
                }.frame(height: 180)
            }.padding()
        }.bgColor().toolbar(.hidden, for: .tabBar)
    }
    
    func idString(gait: Gait, gaits: [Gait]) -> String {
        if gaits.last == gait {
            return "ID \(gait.exam_id)\n(最新)"
        }
        return "ID \(gait.exam_id)"
    }
    
    func totalCalory(gaits: [Gait]) -> Double {
        var totalCalory: Double = 0
        for gait in gaits {
            totalCalory += gait.gait_energy
        }
        return totalCalory
    }
    
    func totalSteps(gaits: [Gait]) -> Int {
        var totalSteps: Int = 0
        for gait in gaits {
            totalSteps += Int(gait.gait_steps)
        }
        return totalSteps
    }
}
