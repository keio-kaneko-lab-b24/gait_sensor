import SwiftUI
import AVFoundation

struct GaitExerciseView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage(wrappedValue: 10,  "sensorHz") private var sensorHz: Int
    @AppStorage(wrappedValue: 5,  "voiceSpeed") private var voiceSpeed: Int
    
    let userId: String
    let examTypeId: Int
    let minutes: Int
    let seconds: Int
    let deviceId = devideId()
    let synthesizer = AVSpeechSynthesizer()
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var currentTime: Int = -3 // カウントダウン分を引いている（秒）
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
        VStack {
            // 歩行開始前: カウントダウン
            if currentTime < 0 {
                VStack {
                    Text("\(-1 * currentTime)").extraLarge()
                }.onChange(of: currentTime) { _ in
                    speechText(text: "\(-1 * currentTime)")
                }.onAppear{
                    speechText(text: "\(-1 * currentTime)") // 最初の1秒分の音声
                }
            }
            
            // 歩行中: データの取得と画面更新
            if currentTime >= 0 {
                Group {
                    Text("ウォーキング").title()
                    Text("目標時間 \(timeToString(time: minutes*60+seconds))").explain()
                    Text("\(timeToString(time: currentTime))").extraLarge()
                    Text("\(String(Int(recordManager.gait?.gait_distance ?? 0))) m").extraLarge()
                }.onAppear{
                    speechText(text: "ウォーキングを開始します")
                    let nextExamId = GaitManager().getLastExamId(gaits: gaits, motionSensors: motionSensors) + 1
                    recordManager.start(
                        userId: userId, examId: nextExamId, examTypeId: examTypeId,
                        motionInterval: 1.0 / Double(sensorHz), context: context)
                }
            }
             
            // 歩行中のみ: 「終了」ボタンを表示
            if currentTime >= 0 && currentTime < (minutes*60+seconds) {
                
                HStack {
                    Button(action: {
                        recordManager.stop()
                        if recordManager.gaitCount == 0 {
                            showAlert2 = true
                        } else {
                            speechText(text: "ウォーキングを終了します")
                            isNextButton = true
                        }
                    } ){
                        Text("終了").button()
                    }
                    .secondary()
                    .alert("歩行データはありません。\n設定画面に戻ります。", isPresented: $showAlert2) {
                        Button("OK") {
                            speechText(text: "ウォーキングを終了します")
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }.padding()
            }
            
            // 歩行終了後：「データを削除」と「保存」ボタンを表示
            if currentTime >= (minutes*60+seconds) {
                
                HStack {
                    
                    Button(action: {
                        showAlert1 = true
                    } ){
                        Text("データを削除").button()
                    }
                    .secondary()
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
                        Text("保存").button()
                    }
                    .primary()
                    .onAppear {
                        timer.upstream.connect().cancel()
                        speechText(text: "ウォーキングを終了します")
                        recordManager.stop()
                    }
                    .alert("歩行データがありません", isPresented: $showAlert2) {
                        Button("OK") { /* Do Nothing */}
                    } message: {
                        Text("歩行データを取得できませんでした。\nやりなおしてください。")
                    }
                }.padding()
            }
        }.onReceive(timer) { _ in
            currentTime += 1
        }.navigationBarBackButtonHidden(true).toolbar(.hidden, for: .tabBar)
        
        NavigationLink(
            destination: ResultView(
                gait: recordManager.gait, showEnergy: true,
                showFinishButton: true),
            isActive: $isNextButton) { EmptyView() }
    }
    
    func speechText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = Float(Double(voiceSpeed) / 10)
        self.synthesizer.speak(utterance)
    }
}
