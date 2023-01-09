import SwiftUI

let theme = UIColor(red: 70/255, green: 150/255, blue: 180/255, alpha: 1)
let theme2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)

extension View {
    
    /*
     全体のスタイル1
     */
    func style() -> some View {
        self.listStyle(.automatic)
            .environment(\.defaultMinListRowHeight, 60)
            .fontWeight(.medium)
            .foregroundColor(Color(theme2))
            .scrollContentBackground(.hidden)
            .accentColor(Color(theme))
    }
    
    /*
     全体のスタイル2（UIKit操作系）
     */
    func modify() -> some View {
        modifier(CGViewModifier(backgroundColor: theme))
    }
    
    /*
     SubViewのスタイル
     */
    func bgColor() -> some View {
        self.background(Color("Bg").ignoresSafeArea())
    }
    
    func card() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
            .background(.white)
            .modifier(CardModifier())
            .padding(.all, 10)
    }
}

struct CGViewModifier: ViewModifier {
    let backgroundColor: UIColor

    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        // ナビゲーション
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = backgroundColor
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white]
        coloredAppearance.backButtonAppearance = backItemAppearance
        
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        coloredAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        // タブ
        let tabAppearance = UITabBarAppearance()
        tabAppearance.shadowColor = backgroundColor
        tabAppearance.backgroundColor = UIColor(Color("Bg"))
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    func body(content: Content) -> some View {
        content
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
    }
}

struct ComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
