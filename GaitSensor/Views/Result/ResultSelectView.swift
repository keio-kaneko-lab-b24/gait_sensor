import SwiftUI

struct ResultSelectView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.end_unixtime)])
    var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    @State var showAlert = false
    let gaitManager = GaitManager()
    let fileManager = UserFileManager()
    
    var body: some View {
        List {
            // ウォーキングの結果画面
            NavigationLink {
                ResultListView(examTypeId: 0)
            } label: {
                HStack {
                    Image(systemName: "chart.bar.doc.horizontal").icon()
                    Text("ウォーキングの記録")
                }
            }
            
            // 歩行機能検査の結果画面
            NavigationLink {
                ResultListView(examTypeId: 1)
            } label: {
                HStack {
                    Image(systemName: "chart.bar.doc.horizontal").icon()
                    Text("歩行機能検査の記録")
                }
            }
        }.toolbar {
            ToolbarItem {
                Button {
                    let gaitText = gaitManager.gaitToCsv(gaits: gaits)
                    fileManager.saveFile(data: gaitText, fileName: "gait.csv")
                    let motionSensorText = gaitManager.motionSensorToCsv(motionSensors: motionSensors)
                    fileManager.saveFile(data: motionSensorText, fileName: "motionSensor.csv")
                    showAlert = true
                } label: {
                    HStack {
                        Text("記録の書き出し").regular()
                        Image(systemName: "square.and.arrow.up").icon()
                    }
                }.alert("運動記録を書き出しました", isPresented: $showAlert) {
                    Button("OK") { /* Do Nothing */}
                } message: {
                    Text("「ファイルアプリ」>「このiPhone内」>「GaitSensor」からファイルを確認できます。")
                }
            }
        }
    }
}
