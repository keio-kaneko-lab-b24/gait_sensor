import SwiftUI
import CoreData

struct DebugView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.end_unixtime)])
    var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    @State private var userId: String = "User1"
    @State private var examTypeId: Int = 0
    @ObservedObject var recordManager = GaitRecordManager()
    
    var body: some View {
        Text("デバッグモード")
        List {
            HStack {
                Text("ユーザID")
                TextField("ユーザID", text: $userId).keyboardType(.decimalPad)
            }
            HStack {
                Text("ExamTypeID")
                TextField("ExamTypeID", value: $examTypeId, formatter: NumberFormatter()).keyboardType(.decimalPad)
            }
        }
        
        HStack(){
            Button(action: {
                let nextExamId = GaitManager().getLastExamId(gaits: gaits, motionSensors: motionSensors)+1
                recordManager.start(userId: userId, examId: nextExamId, examTypeId: examTypeId, motionInterval: 0.1, context: context)
            } ){ Text("Start") }
            Button(action: { recordManager.stop() } ){ Text("Stop") }
            Button(action: { recordManager.delete(gaits: gaits, motionSensors: motionSensors, context: context) } ){ Text("Delete") }
        }.buttonStyle(.bordered)
        
        List {
            Text("START: \(String(recordManager.isStarted)) step")
            Text("経過時間: \(String(format: "%.2f", recordManager.gait?.gait_period ?? 0)) s")
            Text("歩数: \(recordManager.gait?.gait_steps ?? 0) step")
            Text("歩行速度: \(String(format: "%.2f", recordManager.gait?.gait_speed ?? 0)) m/s")
            Text("歩幅: \(String(format: "%.2f", recordManager.gait?.gait_stride ?? 0)) m/step")
            Text("歩行距離: \(String(format: "%.2f", recordManager.gait?.gait_distance ?? 0)) m")
        }
        List {
            ForEach(gaits) { gait in
                Text("\(gait.exam_id): \(gait.gait_steps) 歩, \(gait.gait_distance) m")
            }
            Text("センサー数: \(motionSensors.count)")
        }
    }
    

    
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
