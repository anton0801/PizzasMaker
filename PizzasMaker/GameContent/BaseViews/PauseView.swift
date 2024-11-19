import SwiftUI

struct PauseView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.5))
                .ignoresSafeArea()
            
            Image("paused_bg")
                .resizable()
                .frame(width: 300, height: 200)
            
            VStack {
                HStack {
                    Button {
                        NotificationCenter.default.post(name: Notification.Name("CONTINUE_GAME"), object: nil)
                    } label: {
                        Image("continue_btn")
                            .resizable()
                            .frame(width: 82, height: 82)
                    }
                    Button {
                        NotificationCenter.default.post(name: Notification.Name("HOME_ACTION"), object: nil)
                    } label: {
                        Image("home_btn")
                            .resizable()
                            .frame(width: 82, height: 82)
                    }
                }
                .padding(.top, 42)
            }
        }
    }
}

#Preview {
    PauseView()
}
