import SwiftUI

extension Text {
    func extraLarge() -> some View {
        self.font(.system(size: 100, weight: .bold))
    }
    
    func large() -> some View {
        self.font(.largeTitle).bold()
    }
    
    func title() -> some View {
        self.font(.title).bold()
    }
    
    func title2() -> some View {
        self.font(.title2).bold()
    }
    
    func explain() -> some View {
        self.font(.footnote)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
    
    func regular() -> some View {
        self.fontWeight(.regular)
    }
    
    func button() -> some View {
        self.frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40).bold()
    }
}
