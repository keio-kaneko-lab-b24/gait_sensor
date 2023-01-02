import SwiftUI

struct GaitExamSelectView: View {
    let userId: String
    let examTypeId: Int
    
    var body: some View {
        
        List {
            NavigationLink {
                GaitExamSettingView(userId: userId, examTypeId: examTypeId, examSpeedTypeId: 0)
            } label: {
                Text("最大歩行検査")
            }
            
            NavigationLink {
                GaitExamSettingView(userId: userId, examTypeId: examTypeId, examSpeedTypeId: 1)
            } label: {
                Text("快適歩行検査")
            }
        }
    }
}
