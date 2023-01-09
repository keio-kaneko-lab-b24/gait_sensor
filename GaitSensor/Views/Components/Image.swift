import SwiftUI

extension Image {
    func icon() -> some View {
        self.frame(width: 30, height: 30).foregroundColor(Color(theme))
    }
    
    func toolbarIcon() -> some View {
        self.frame(width: 30, height: 30).foregroundColor(.white)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
