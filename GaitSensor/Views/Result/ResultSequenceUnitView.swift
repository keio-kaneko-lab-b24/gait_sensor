import SwiftUI
import Charts

struct ResultSequenceUnitView: View {
    let gaits: [Gait]
    let examTypeId: Int
    let unit: Calendar.Component
    let unitText: String
    var showEnergy: Bool = false
    @State var isSelectedButton = false
    
    var body: some View {
        let dates = lastDates(n: 6, unit: unit)
        
        ScrollView(.vertical) {
            if showEnergy {
                // 歩数
                VStack {
                    VStack {
                        Text("歩数").title2()
                        Text("\(unitText)の合計歩数").explain()
                        Chart(dates) { date in
                            BarMark (
                                x: .value("日付", date.date, unit: unit),
                                y: .value("歩数", periodSum(gaits: gaits, date: date.date, item: .steps, unit: unit))
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
                        Text("\(unitText)の合計消費エネルギー（kcal）").explain()
                        Chart(dates) { date in
                            BarMark (
                                x: .value("日付", date.date, unit: unit),
                                y: .value("消費エネルギー", periodSum(gaits: gaits, date: date.date, item: .energy, unit: unit))
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
                    Text("\(unitText)の最大歩行速度（m/分）").explain()
                    Chart(dates) { date in
                        BarMark (
                            x: .value("日付", date.date, unit: unit),
                            y: .value("速度", periodMax(gaits: gaits, date: date.date, item: .speed, unit: unit))
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
                    Text("\(unitText)の最大歩幅（m）").explain()
                    Chart(dates) { date in
                        BarMark (
                            x: .value("日付", date.date, unit: unit),
                            y: .value("歩幅", periodMax(gaits: gaits, date: date.date, item: .stride, unit: unit))
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
                    Text("\(unitText)の最大歩行率（歩/分）").explain()
                    Chart(dates) { date in
                        BarMark (
                            x: .value("日付", date.date, unit: unit),
                            y: .value("歩行率", periodMax(gaits: gaits, date: date.date, item: .pace, unit: unit))
                        )
                        .foregroundStyle(Color.pink.opacity(0.85))
                        .cornerRadius(10)
                    }.frame(height: 180)
                }.padding()
            }.card()
                
        }.bgColor().toolbar(.hidden, for: .tabBar)
    }
}

struct ResultSequenceDailyView_Previews: PreviewProvider {
    static var previews: some View {
        ResultSequenceUnitView(gaits: [], examTypeId: 0, unit: .day, unitText: "")
    }
}
