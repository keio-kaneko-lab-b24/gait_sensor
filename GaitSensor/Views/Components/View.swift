import SwiftUI

extension View {
    func navigationBarColor() -> some View {
        self.toolbarBackground(Color.blue.opacity(0.4), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    func style() -> some View {
        self.listStyle(.automatic)
            .environment(\.defaultMinListRowHeight, 60)
            .font(.system(.body, design: .rounded))
            .fontWeight(.medium)
            .opacity(0.8)
    }
}
