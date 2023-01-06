import SwiftUI

extension View {
    func navigationBarColor() -> some View {
        self.toolbarBackground(Color.teal.opacity(0.4), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    func style() -> some View {
        self.listStyle(.automatic)
            .environment(\.defaultMinListRowHeight, 60)
            .fontWeight(.medium)
            .opacity(0.8)
            .scrollContentBackground(.hidden)
    }
    
    func bgColor() -> some View {
        self.background(Color("Bg").ignoresSafeArea())
    }
}
