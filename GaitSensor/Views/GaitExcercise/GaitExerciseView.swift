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
    let synthesizer = AVSpeechSynthesizer()
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var currentTime: Int = -3 // カウントダウン分を引いている
    @State var pauseTimer = false
    @State var showAlert1 = false
    @State var showAlert2 = false
    @State var isBackButton = false
    @State var isNextButton = false
    @ObservedObject var recordManager = GaitRecordManager()
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.end_unixtime)])
    var gaits: FetchedResults<Gait>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    var body: some View {
        Group {
            // 歩行開始前: カウントダウン
            if currentTime < 0 {
                Group {
                    Text("\(-1 * currentTime)").font(.largeTitle).bold()
                }.onChange(of: currentTime) { _ in
                    speechText(text: "\(-1 * currentTime)")
                }.onAppear{
                    speechText(text: "\(-1 * currentTime)") // 最初の1秒分の音声
                }
            }
            
            // 歩行中: データの取得と画面更新
            if currentTime >= 0 {
                Group {
                    Text("ウォーキング").font(.title).padding()
                    Text("\(timeToString(time: currentTime))").font(.largeTitle).bold()
                    Text("\(String(floor(recordManager.gait?.gait_distance ?? 0))) M").font(.largeTitle).bold()
                }.onAppear{
                    speechText(text: "ウォーキングを開始します")
                    let nextExamId = GaitManager().getLastExamId(gaits: gaits, motionSensors: motionSensors) + 1
                    recordManager.start(
                        userId: userId, examId: nextExamId, examTypeId: examTypeId,
                        motionInterval: 0.1, context: context)
                }
            }
             
            // 歩行中のみ: 「一時停止」と「終了」ボタンを表示
            if currentTime >= 0 && currentTime < (minutes*60+seconds) {
                HStack {
//                    if pauseTimer == false {
//                        Button(action: {
//                            timer.upstream.connect().cancel()
//                            pauseTimer = true
//                        } ){Text("一時中断")}.buttonStyle(.bordered)
//                    } else {
//                        Button(action: {
//                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//                            pauseTimer = false
//                        } ){Text("再開")}.buttonStyle(.bordered)
//                    }
                    
                    
                    Button(action: {
                        recordManager.stop()
                        if recordManager.gaitCount == 0 {
                            showAlert2 = true
                        } else {
                            isNextButton = true
                        }
                    } ){
                        Text("終了")
                    }
                    .buttonStyle(.bordered)
                    .alert("歩行データはありません。\n設定画面に戻ります。", isPresented: $showAlert2) {
                        Button("OK") {
                            speechText(text: "ウォーキングを終了します")
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                }
            }
            
            // 歩行終了後：「データを削除」と「保存」ボタンを表示
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
                        Text("削除したデータは元に戻せません。\n削除しますか？")
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
                        Text("歩行データを取得できませんでした。\n再度やりなおしてください。")
                    }
                }
                
            }
        }.onReceive(timer) { _ in
            currentTime += 1
            if currentTime >= (minutes*60+seconds) {
                timer.upstream.connect().cancel()
            }
        }.navigationBarBackButtonHidden(true)
        
        NavigationLink(
            destination: ResultView(
                gait: recordManager.gait, showEnergy: true,
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
