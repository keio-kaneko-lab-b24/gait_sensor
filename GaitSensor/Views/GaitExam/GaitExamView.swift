import SwiftUI
import AVFoundation

struct GaitExamView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let userId: String
    let examTypeId: Int
    let examSpeedTypeId: Int
    let meter: Int
    let motionInterval: Double = 0.1
    let deviceId = devideId()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let synthesizer = AVSpeechSynthesizer()
    
    @State var currentTime: Int = -3 // カウントダウン分を引いている
    @State var showAlert1 = false
    @State var showAlert2 = false
    @State var isBackButton = false
    @State var isNextButton = false
    @ObservedObject var recordManager = GaitRecordManager()
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id)])
    var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    var body: some View {
        Group {
            // 歩行開始前: カウントダウン
            if currentTime < 0 {
                Group {
                    Text("\(-1 * currentTime)").font(.largeTitle)
                }.onChange(of: currentTime) { _ in
                    speechText(text: "\(-1 * currentTime)")
                }.onAppear{
                    speechText(text: "\(-1 * currentTime)") // 最初の1秒分の音声
                }
            }
            
            // 歩行中: データの取得と画面更新
            if currentTime >= 0 {
                Group {
                    if examSpeedTypeId == 0 {
                        Text("最大速度歩行").font(.title)
                    }
                    if examSpeedTypeId == 1 {
                        Text("快適速度歩行").font(.title)
                    }
                    Text("\(String(floor(recordManager.gait?.gait_distance ?? 0))) M").font(.largeTitle)
                }.onAppear{
                    speechText(text: "検査を開始します")
                    let nextExamId = GaitManager().getLastExamId(gaits: gaits, motionSensors: motionSensors)+1
                    recordManager.start(
                        userId: userId, examId: nextExamId, examTypeId: examTypeId,
                        motionInterval: 0.1, context: context)
                }
            }
            
            // 歩行終了後：「最初から」と「保存」ボタンを表示
            if recordManager.gait?.gait_distance ?? 0 >= Double(meter) {
                
                HStack {
                    Button(action: {
                        showAlert1 = true
                    } ){
                        Text("最初から")
                    }
                    .buttonStyle(.bordered)
                    .alert("注意", isPresented: $showAlert1) {
                        Button("最初から", role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                            recordManager.delete(gaits: gaits, motionSensors: motionSensors, context: context)
                        }
                    } message: {
                        Text("今回の記録は削除されます。よろしいですか？")
                    }
                    
                    Button(action: {
                        if recordManager.gaitCount == 0 {
                            showAlert2 = true
                        } else {
                            isNextButton = true
                        }
                    } ){
                        Text("保存")
                    }
                    .buttonStyle(.bordered)
                    .onAppear {
                        speechText(text: "検査を終了します")
                        recordManager.stop()
                    }
                    .alert("歩行データがありません", isPresented: $showAlert2) {
                        Button("OK") { /* Do Nothing */}
                    } message: {
                        Text("歩行データを取得できませんでした。再度やりなおしてください。")
                    }
                }
                
            }
        }
        .onReceive(timer) { _ in
            currentTime += 1
            if currentTime >= 0 {
                timer.upstream.connect().cancel()
            }
        }
        
        NavigationLink(
            destination: ResultView(
                gait: gaits.last,
                showFinishButton: true),
            isActive: $isNextButton) { EmptyView() }
    }
    
    func speechText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
    }
}