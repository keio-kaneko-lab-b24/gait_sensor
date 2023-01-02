import SwiftUI

struct ResultView: View {
    let gait: Gait
    var showFinishButton: Bool = false
    @State var isFinishButton = false
    
    var body: some View {
        
        List {
            HStack {
                Text("開始時間")
                Spacer()
                Text(unixtimeToDateString(unixtime: Int(gait.start_unixtime)))
            }
            
            HStack {
                Text("終了時間")
                Spacer()
                Text(unixtimeToDateString(unixtime: Int(gait.end_unixtime)))
            }
            
            HStack {
                Text("エクササイズ時間")
                Spacer()
                Text("\(Int(gait.gait_period)) 秒")
            }
            
            HStack {
                Text("歩数")
                Spacer()
                Text("\(gait.gait_steps) 歩")
            }
            
            HStack {
                Text("歩行率")
                Spacer()
                let step_rate = 60 * Double(gait.gait_steps) / Double(gait.gait_period)
                Text("1分あたり \(String(format: "%.1f", step_rate)) 歩")
            }
            
            HStack {
                Text("歩行速度")
                Spacer()
                let speed = 60 * gait.gait_speed
                Text("1分あたり \(String(format: "%.1f", speed)) メートル")
            }
            
            HStack {
                Text("歩幅")
                Spacer()
                Text("\(String(format: "%.1f", gait.gait_stride)) メートル")
            }
            
            HStack {
                Text("歩行距離")
                Spacer()
                Text("\(String(format: "%.1f", gait.gait_distance)) メートル")
            }
            
            if showFinishButton {
                Button(action: {
                    isFinishButton = true
                } ){
                    Text("ホームに戻る").bold()
                }
            }
        }
        
        NavigationLink(
            destination: HomeView(),
            isActive: $isFinishButton) { EmptyView() }
    }
}
