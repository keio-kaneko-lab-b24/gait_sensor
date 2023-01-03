import SwiftUI
import Charts

struct ResultSequenceView: View {
    let gaits: [Gait]
    
    var body: some View {
        var gaitsSorted = gaits.sorted(by: {$0.exam_id < $1.exam_id})
        ScrollView(.vertical) {
            // 歩行速度
            VStack {
                Text("歩行速度").font(.title).bold()
                Text("1分あたりに何メートル移動したか").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary)
                Chart(gaitsSorted.suffix(10)) { gait in
                    BarMark (
                        x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                        y: .value("歩行速度", Double(gait.gait_speed) * 60)
                    )
                    .foregroundStyle(Color.pink.opacity(0.7))
                    .cornerRadius(10)
                }.frame(height: 180)
            }.padding()
            
            // 歩幅
            VStack {
                Text("歩幅").font(.title).bold()
                Text("1歩あたりの歩幅は何メートルか").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary)
                Chart(gaitsSorted.suffix(10)) { gait in
                    BarMark (
                        x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                        y: .value("歩幅", Double(gait.gait_stride))
                    )
                    .foregroundStyle(Color.pink.opacity(0.7))
                    .cornerRadius(10)
                }.frame(height: 180)
            }.padding()
            
            // 歩行率
            VStack {
                Text("歩行率").font(.title).bold()
                Text("1分あたり何歩歩いたか").fontWeight(.semibold).font(.footnote).foregroundColor(.secondary)
                Chart(gaitsSorted.suffix(10)) { gait in
                    BarMark (
                        x: .value("ID", idString(gait: gait, gaits: gaitsSorted)),
                        y: .value("歩幅", Double(60 * gait.gait_steps / gait.gait_period))
                    )
                    .foregroundStyle(Color.pink.opacity(0.7))
                    .cornerRadius(10)
                }.frame(height: 180)
            }.padding()
        }
    }
    
    func idString(gait: Gait, gaits: [Gait]) -> String {
        if gaits.last == gait {
            return "ID \(gait.exam_id)\n(最新)"
        }
        return "ID \(gait.exam_id)"
    }
}
