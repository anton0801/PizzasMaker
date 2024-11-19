import SwiftUI
import WebKit
import SpriteKit

struct PizzaRunnerGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @State var pizzaRunnerGame: PizzaRunnerGameScene!
    
    @State var paused = false
    @State var gameOver = false
    
    @State var coins = 0
    @State var score = 0
    
    var body: some View {
        ZStack {
            VStack {
                if let pizzaRunnerGame = pizzaRunnerGame {
                    SpriteView(scene: pizzaRunnerGame)
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
            pizzaRunnerGame = PizzaRunnerGameScene()
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
            pizzaRunnerGame.isPaused = false
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("HOME_ACTION"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_OVER"))) { notification in
            guard let userInfo = notification.userInfo as? [String: Any],
                  let coins = userInfo["coins"] as? Int,
                  let score = userInfo["score"] as? Int else { return }
            self.coins = coins
            self.score = score
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
                    Text("Score")
                        .font(.custom("Tomcat", size: 24))
                        .foregroundColor(.red)
                    Text("\(score)")
                        .font(.custom("Tomcat", size: 52))
                        .foregroundColor(.white)
                    
                    Text("Picked Coins")
                        .font(.custom("Tomcat", size: 24))
                        .foregroundColor(.red)
                    HStack {
                        Text("\(score)")
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



extension PizzaMaker4CookersSceneView {
    
    func reloadcookers() {
        sceneContainerView.reload()
    }
    
    func toInitialCookers() {
        cookersWorkingNowList.forEach { $0.removeFromSuperview() }
        cookersWorkingNowList.removeAll()
        NotificationCenter.default.post(name: .hideNavigation, object: nil)
        sceneContainerView.load(URLRequest(url: cookersSkin))
    }
    
    func applyDataForSkinsCookers() {
        if let skinsData = getSavedSkinsForCookers().savedSkins {
            for (_, skinItemList) in skinsData {
                for (_, skinItem) in skinItemList {
                    let skinValue = skinItem as? [HTTPCookiePropertyKey: AnyObject]
                    if let skinValueA = skinValue,
                       let resultSkin = HTTPCookie(properties: skinValueA) {
                        sceneContainerView.configuration.websiteDataStore.httpCookieStore.setCookie(resultSkin)
                    }
                }
            }
        }
    }
}

#Preview {
    PizzaRunnerGameView()
}
