import SwiftUI

struct ResultHomeView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.end_unixtime)])
    var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    @State var showAlert = false
    @State var showAlert2 = false
    let gaitManager = GaitManager()
    let fileManager = UserFileManager()
    
    var body: some View {
        List {
            Section {
                // エクササイズの結果画面
                NavigationLink {
                    ResultListView(examTypeId: 0)
                } label: {
                    HStack {
                        Image(systemName: "chart.bar.fill").icon()
                        Text("エクササイズの記録")
                    }
                }
                
                // 歩行機能検査の結果画面
                NavigationLink {
                    ResultListView(examTypeId: 1)
                } label: {
                    HStack {
                        Image(systemName: "chart.bar.fill").icon()
                        Text("歩行機能検査の記録")
                    }
                }
                
                Button {
                    showAlert = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up.fill").icon()
                        Text("記録の書き出し")
                    }
                }.alert("運動記録を書き出しますか？", isPresented: $showAlert) {
                    Button("Cancel") {}
                    Button("OK") {
                        toCsv()
                        showAlert2 = true
                    }
                }.alert("運動記録を書き出しました", isPresented: $showAlert2) {
                    Button("OK") { /* Do Nothing */}
                } message: {
                    Text("「ファイルアプリ」>「このiPhone内」>「歩行アプリ」からファイルを確認できます。")
                }
            }
            .navigationBarTitle(Text("記録"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        }.bgColor()
    }
    
    func toCsv() {
        let date = currentDateString()
        let gaitText = gaitManager.gaitToCsv(gaits: gaits)
        fileManager.saveFile(data: gaitText, fileName: "gait_\(date).csv")
        let motionSensorText = gaitManager.motionSensorToCsv(motionSensors: motionSensors)
        fileManager.saveFile(data: motionSensorText, fileName: "sensor_\(date).csv")
    }
}

struct ResultHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ResultHomeView()
    }
}
