import SwiftUI
import Charts

struct ResultSequenceView: View {
    let gaits: [Gait]
    var examTypeId: Int
    var showEnergy: Bool = false
    
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
                        Text("累計歩数").title2()
                        Text("どれだけの歩数歩いたか").explain()
                        HStack {
                            Text("\(totalSteps(gaits: gaitsSorted))").large()
                            Text("歩")
                        }
                    }.padding()
                }.card()
                
                // 消費エネルギー
                VStack {
                    VStack {
                        Text("累計消費エネルギー").title2()
                        Text("どれだけのエネルギーを消費したか").explain()
                        HStack {
                            Text("\(Int(totalCalory(gaits: gaitsSorted)))").large()
                            Text("kcal")
                        }
                    }.padding()
                }.card()
            }
            
            // 歩行速度
            VStack {
                VStack {
                    Text("歩行速度").title2()
                    Text("1分あたりに何mの速度で歩いたか").explain()
                    Chart(gaitsSorted.suffix(6)) { gait in
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
                    Text("1歩あたりの歩幅は何mか").explain()
                    Chart(gaitsSorted.suffix(6)) { gait in
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
                    Text("1分あたり何歩のペースで歩いたか").explain()
                    Chart(gaitsSorted.suffix(6)) { gait in
                        BarMark (
                            x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                            y: .value("歩幅", 60 * Double(gait.gait_steps) / ((Double(gait.gait_period) / 1000)))
                        )
                        .foregroundStyle(Color.pink.opacity(0.85))
                        .cornerRadius(10)
                    }.frame(height: 180)
                }.padding()
            }.card()
            
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

struct ResultSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        ResultSequenceView(gaits: [], examTypeId: 0)
    }
}
