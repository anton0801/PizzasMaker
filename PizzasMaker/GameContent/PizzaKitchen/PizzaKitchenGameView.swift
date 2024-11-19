import SwiftUI
import SpriteKit

struct PizzaKitchenGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @State var pizzasKitchesScenes: PizzasKitchesScenes!
    
    @State var paused = false
    @State var gameOver = false
    
    @State var pizzasCount = 0
    @State var time = 0
    
    var body: some View {
        ZStack {
            VStack {
                if let pizzasKitchesScenes = pizzasKitchesScenes {
                    SpriteView(scene: pizzasKitchesScenes)
                        .ignoresSafeArea()
                }
            }
            
            if paused {
                PauseView()
            }
            
            if gameOver {
                gameOverDialog
            }
        }
        .onAppear {
            pizzasKitchesScenes = PizzasKitchesScenes()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PAUSE_BTN"))) { _ in
            withAnimation(.easeInOut) {
                self.paused = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CONTINUE_GAME"))) { _ in
            withAnimation(.linear) {
                self.paused = false
            }
            pizzasKitchesScenes.isPaused = false
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("HOME_ACTION"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_OVER"))) { notification in
            guard let userInfo = notification.userInfo as? [String: Any],
                  let pizzas = userInfo["pizzas"] as? Int,
                  let time = userInfo["time"] as? Int else { return }
            self.pizzasCount = pizzas
            self.time = time
            withAnimation(.easeInOut) {
                self.gameOver = true
            }
        }
    }
    
    @State private var moveUpDown = false
    
    private var gameOverDialog: some View {
        ZStack {
            Image("win_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                .offset(y: moveUpDown ? -50 : 50) // Движение вверх-вниз
                .animation(
                    Animation.easeInOut(duration: 3.5)
                        .repeatForever(autoreverses: true),
                    value: moveUpDown
                )
                .onAppear {
                    moveUpDown.toggle() // Запуск анимации
                }
            
            Image("game_over_bg")
                .resizable()
                .frame(width: 600, height: 330)
            
            HStack {
                Image("you_win")
                    .resizable()
                    .frame(width: 280, height: 260)
                Spacer()
                VStack {
                    Text("Pizzas Made")
                        .font(.custom("Tomcat", size: 24))
                        .foregroundColor(.red)
                    Text("\(pizzasCount)")
                        .font(.custom("Tomcat", size: 52))
                        .foregroundColor(.white)
                    
                    Text("Time")
                        .font(.custom("Tomcat", size: 24))
                        .foregroundColor(.red)
                    HStack {
                        Text("\(formatSeconds(time))")
                            .font(.custom("Tomcat", size: 52))
                            .foregroundColor(.white)
                        Image("coin_runner")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back_to_menu")
                            .resizable()
                            .frame(width: 170, height: 50)
                    }
                    
                    HStack {
                        Spacer()
                    }
                }
            }
            .frame(width: 520, height: 330)
        }
    }
}

#Preview {
    PizzaKitchenGameView()
}

func formatSeconds(_ seconds: Int) -> String {
    if seconds >= 60 {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    } else {
        return "\(seconds)"
    }
}
