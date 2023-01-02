import SwiftUI
import AVFoundation

struct GaitExerciseView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let userId: String
    let examTypeId: Int
    let minutes: Int
    let seconds: Int
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
                    Text("ウォーキング").font(.title)
                    Text("\(timeToString(time: currentTime))").font(.largeTitle)
                    Text("\(String(floor(recordManager.gait?.gait_distance ?? 0))) M").font(.largeTitle)
                }.onAppear{
                    speechText(text: "ウォーキングを開始します")
                    let nextExamId = GaitManager().getLastExamId(gaits: gaits, motionSensors: motionSensors)+1
                    recordManager.start(
                        userId: userId, examId: nextExamId, examTypeId: examTypeId,
                        motionInterval: 0.1, context: context)
                }
            }
            
            // 歩行終了後：「最初から」と「保存」ボタンを表示
            if currentTime >= (minutes*60+seconds) {
                
                HStack {
                    Button(action: {
                        showAlert1 = true
                    } ){
                        Text("データを削除")
                    }
                    .buttonStyle(.bordered)
                    .alert("注意", isPresented: $showAlert1) {
                        Button("削除", role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                            recordManager.delete(gaits: gaits, motionSensors: motionSensors, context: context)
                        }
                    } message: {
                        Text("削除したデータは元に戻せません。削除しますか？")
                    }
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
                    speechText(text: "ウォーキングを終了します")
                    recordManager.stop()
                }
                .alert("歩行データがありません", isPresented: $showAlert2) {
                    Button("OK") { /* Do Nothing */}
                } message: {
                    Text("歩行データを取得できませんでした。再度やりなおしてください。")
                }
                
            }
        }.onReceive(timer) { _ in
            currentTime += 1
            if currentTime >= (minutes*60+seconds) {
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
