import SwiftUI

struct LoadedContentView: View {
    
    @EnvironmentObject var loadingSplashVm: LoadingSplashVm
    
    var body: some View {
        VStack {
            if loadingSplashVm.status != nil {
                PizzaKitchenes4CookersView()
            } else {
                if !UserDefaults.standard.bool(forKey: "onb_pas") {
                    OnBoardingView()
                } else {
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    LoadedContentView()
        .environmentObject(LoadingSplashVm())
}
