import SwiftUI
import Charts

struct ResultSequenceDailyView: View {
    let gaits: [Gait]
    var examTypeId: Int
    var showEnergy: Bool = false
    @State var isSelectedButton = false
    
    var body: some View {
        let days = lastDays(n: 6)
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
                        Text("1日の合計歩数").explain()
                        Chart(days) { day in
                            BarMark (
                                x: .value("日付", day.day, unit: .day),
                                y: .value("歩数", dailySum(gaits: gaits, date: day.day, item: "steps"))
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
                        Text("1日の合計消費エネルギー（kcal）").explain()
                        Chart(days) { day in
                            BarMark (
                                x: .value("日付", day.day, unit: .day),
                                y: .value("消費エネルギー", dailySum(gaits: gaits, date: day.day, item: "energy"))
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
                    Text("1日の最大歩行速度（m/分）").explain()
                    Chart(days) { day in
                        BarMark (
                            x: .value("日付", day.day, unit: .day),
                            y: .value("速度", dailyMax(gaits: gaits, date: day.day, item: "speed"))
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
                    Text("1日の最大歩幅（m）").explain()
                    Chart(days) { day in
                        BarMark (
                            x: .value("日付", day.day, unit: .day),
                            y: .value("歩幅", dailyMax(gaits: gaits, date: day.day, item: "stride"))
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
                    Text("1日の最大歩行率（歩/分）").explain()
                    Chart(days) { day in
                        BarMark (
                            x: .value("日付", day.day, unit: .day),
                            y: .value("歩行率", dailyMax(gaits: gaits, date: day.day, item: "pace"))
                        )
                        .foregroundStyle(Color.pink.opacity(0.85))
                        .cornerRadius(10)
                    }.frame(height: 180)
                }.padding()
            }.card()
                
        }.bgColor().toolbar(.hidden, for: .tabBar)
    }
    
    func dailySum(gaits: [Gait], date: Date, item: String) -> Double {
        return gaits.filter {
            let gait_date = unixtimeToDate(unixtimeMillis: Int($0.start_unixtime))
            return sameDays(date1: date, date2: gait_date)
        }.map {
            if (item == "steps") { return Double($0.gait_steps) }
            else if (item == "energy") { return Double($0.gait_energy) }
            else { return 0 }
        }.max() ?? 0
    }
    
    func dailyMax(gaits: [Gait], date: Date, item: String) -> Double {
        return gaits.filter {
            let gait_date = unixtimeToDate(unixtimeMillis: Int($0.start_unixtime))
            return sameDays(date1: date, date2: gait_date)
        }.map {
            if (item == "speed") { return Double($0.gait_speed) * 60 }
            else if (item == "stride") { return Double($0.gait_stride) }
            else if (item == "pace") {
                return 60 * Double($0.gait_steps) / ((Double($0.gait_period) / 1000))
            }
            else { return 0 }
        }.max() ?? 0
    }

}

struct ResultSequenceDailyView_Previews: PreviewProvider {
    static var previews: some View {
        ResultSequenceDailyView(gaits: [], examTypeId: 0)
    }
}
