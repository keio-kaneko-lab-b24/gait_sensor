import SwiftUI

struct ResultListView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id)])
    var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    let gaitManager = GaitManager()
    
    let examTypeId: Int
    
    var body: some View {
        Text("左スワイプでデータを削除できます。")
        List {
            ForEach(lastGaitByExamId(gaits: gaits)) { gait in
                Group {
                    if gait.exam_type_id == examTypeId {
                        NavigationLink {
                            ResultView(gait: gait)
                        } label: {
                            Text(unixtimeToDateString(unixtime: Int(gait.start_unixtime), short: true))
                            Image(systemName: "figure.walk")
                            Text("\(gait.gait_steps) 歩")
                        }
                    }
                }
            }.onDelete(perform: delete)
        }
    }
    
    // Gaitは取得したタイミングで全部保存されているので、ExamIdごとに最後のみを使用する
    func lastGaitByExamId(gaits: FetchedResults<Gait>) -> [Gait] {
        let gaitDict = Dictionary(grouping: gaits, by: { $0.exam_id })
        var gaitList: [Gait] = []
        for elem in gaitDict {
            gaitList.append(elem.value.last!)
        }
        gaitList.sort(by: {$0.start_unixtime > $1.start_unixtime})
        return gaitList
    }
    
    // ExamIdに紐づくGaitとMotionSensorを削除する。
    func delete(offsets: IndexSet) {
        offsets.forEach { index in
            let lastGaits = lastGaitByExamId(gaits: gaits)
            let exam_id = Int(lastGaits[index].exam_id)
            gaitManager.deleteGait(gaits: gaits, examId: exam_id, context: context)
            gaitManager.deleteMotionSensor(motionSensors: motionSensors, examId: exam_id, context: context)
        }
    }
}

