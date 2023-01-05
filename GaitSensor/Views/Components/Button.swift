import SwiftUI

extension Button {
    func primary() -> some View {
        self.buttonStyle(.borderedProminent)
            .tint(.blue)
    }
    
    func secondary() -> some View {
        self.buttonStyle(.bordered)
    }
}
