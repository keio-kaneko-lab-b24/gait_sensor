import SwiftUI

struct ResultView: View {
    let gait: Gait?
    var showEnergy: Bool = false
    var showFinishButton: Bool = false
    @State var isFinishButton = false
    
    var body: some View {
        
        VStack {
            if showFinishButton {
                Text("記録が完了しました")
            } else {
                Text("記録詳細").font(.title2).bold()
            }
        }
        
        List {
            if gait != nil {
                HStack {
                    Text("開始時間")
                    Spacer()
                    Text(unixtimeToDateString(unixtime: Int(gait!.start_unixtime)))
                }
                
                HStack {
                    Text("終了時間")
                    Spacer()
                    Text(unixtimeToDateString(unixtime: Int(gait!.end_unixtime)))
                }
                
                HStack {
                    Text("歩行時間")
                    Spacer()
                    Text("\(Int(gait!.gait_period)) 秒")
                }
                
                HStack {
                    Text("歩数")
                    Spacer()
                    Text("\(gait!.gait_steps) 歩")
                }
                
                HStack {
                    Text("歩行率")
                    Spacer()
                    let step_rate = 60 * Double(gait!.gait_steps) / Double(gait!.gait_period)
                    Text("1分あたり \(String(format: "%.1f", step_rate)) 歩")
                }
                
                HStack {
                    Text("歩行速度")
                    Spacer()
                    let speed = 60 * gait!.gait_speed
                    Text("1分あたり \(String(format: "%.1f", speed)) メートル")
                }
                
                HStack {
                    Text("歩幅")
                    Spacer()
                    Text("\(String(format: "%.1f", gait!.gait_stride)) メートル")
                }
                
                HStack {
                    Text("歩行距離")
                    Spacer()
                    Text("\(String(format: "%.1f", gait!.gait_distance)) メートル")
                }
                
                if showEnergy {
                    HStack {
                        Text("推定消費エネルギー")
                        Spacer()
                        Text("\(String(format: "%.1f", gait!.gait_energy)) kcal")
                    }
                    
                    HStack {
                        Text("推定燃焼脂肪量")
                        Spacer()
                        Text("\(String(format: "%.1f", gait!.gait_energy / 9)) g")
                    }
                }
            }
            
            if showFinishButton {
                Button(action: {
                    isFinishButton = true
                } ){
                    Text("ホームに戻る").bold()
                }
            }
        }.navigationBarBackButtonHidden(showFinishButton)
        
        NavigationLink(
            destination: HomeView(),
            isActive: $isFinishButton) { EmptyView() }
    }
}
