import SwiftUI

struct ResultView: View {
    
    let gait: Gait?
    var showEnergy: Bool = false
    var showFinishButton: Bool = false
    @State var isFinishButton = false
    
    var body: some View {
        
        if showFinishButton {
            VStack {
                Text("記録が完了しました").title()
            }.padding()
        }

        List {
            Section {
                if gait != nil {
                    HStack {
                        Text("開始時間")
                        Spacer()
                        Text(unixtimeToDateString(unixtimeMillis: Int(gait!.start_unixtime)))
                    }
                    
                    HStack {
                        Text("終了時間")
                        Spacer()
                        Text(unixtimeToDateString(unixtimeMillis: Int(gait!.end_unixtime)))
                    }
                    
                    HStack {
                        Text("歩行時間")
                        Spacer()
                        Text("\(String(format: "%.1f", Double(gait!.gait_period) / 1000)) 秒")
                    }
                    
                    HStack {
                        Text("歩数")
                        Spacer()
                        Text("\(gait!.gait_steps) 歩")
                    }
                    
                    HStack {
                        Text("歩行率")
                        Spacer()
                        let step_rate = 60 * Double(gait!.gait_steps) / (Double(gait!.gait_period) / 1000)
                        Text("\(String(format: "%.1f", step_rate)) 歩/分")
                    }
                    
                    HStack {
                        Text("歩行速度")
                        Spacer()
                        let speed = 60 * gait!.gait_speed
                        Text("\(String(format: "%.1f", speed)) m/分")
                    }
                    
                    HStack {
                        Text("歩幅")
                        Spacer()
                        Text("\(String(format: "%.1f", gait!.gait_stride)) m")
                    }
                    
                    HStack {
                        Text("歩行距離")
                        Spacer()
                        Text("\(String(format: "%.1f", gait!.gait_distance)) m")
                    }
                    
                    if showEnergy {
                        HStack {
                            Text("推定消費エネルギー")
                            Spacer()
                            let energy = gait!.gait_energy
                            if energy == 0 {
                                Text("体重が未設定")
                            } else {
                                Text("\(String(format: "%.1f", energy)) kcal")
                            }
                        }
                        
                        HStack {
                            Text("推定燃焼脂肪量")
                            Spacer()
                            let fat = gait!.gait_energy / 9
                            if fat == 0 {
                                Text("体重が未設定")
                            } else {
                                Text("\(String(format: "%.1f", fat)) g")
                            }
                        }
                    }
                }
            } footer: {
                if showFinishButton {
                    Button(action: {
                        isFinishButton = true
                    } ){
                        Text("ホームに戻る").button()
                    }
                    .secondary()
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(showFinishButton).bgColor()
        .toolbar(.visible, for: .tabBar)
        
        NavigationLink(
            destination: GaitHomeView(),
            isActive: $isFinishButton) { EmptyView() }
    }
}
