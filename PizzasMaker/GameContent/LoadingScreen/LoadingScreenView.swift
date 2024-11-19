import SwiftUI

struct FallingObject: Identifiable {
    let id: UUID
    let imageName: String
    var xPosition: CGFloat
    var yPosition: CGFloat
    let fallDuration: Double
}

struct LoadingScreenView: View {
    
    @State private var fallingObjects: [FallingObject] = []
    @State private var timer: Timer? = nil
    
    @StateObject var loadingSplashVm = LoadingSplashVm()
    @State var loaded = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("loading_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width + 100, minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                
                ForEach(fallingObjects) { object in
                    Image(object.imageName)
                        .resizable()
                        .frame(width: 82, height: 82)
                        .position(x: object.xPosition, y: object.yPosition)
                        .onAppear {
                            withAnimation(.linear(duration: object.fallDuration)) {
                                moveObjectToBottom(object)
                            }
                        }
                }
                
                Rectangle()
                    .fill(.black.opacity(0.6))
                    .ignoresSafeArea()
                
                VStack {
                    Image("loading_title")
                        .resizable()
                        .frame(width: 300, height: 120)
                    
                    NavigationLink(destination: LoadedContentView()
                        .environmentObject(loadingSplashVm)
                        .navigationBarBackButtonHidden(), isActive: $loaded) {
                            
                        }
                }
                
                if loadingSplashVm.loadedGAme {
                    if loadingSplashVm.status != nil {
                        Text("")
                            .onAppear {
                                loaded = true
                            }
                    } else {
                        Text("")
                            .onAppear {
                                PizzasMakerAppDelegate.screePos = .landscape
                                loaded = true
                            }
                    }
                }
            }
            .onAppear {
                startFallingObjects()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("fcm_received")), perform: { _ in
                loadingSplashVm.hasComePushToken = true
                loadingSplashVm.startObtainingDailyRewardsAndSaveIt()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func startFallingObjects() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { _ in
            let newObject = FallingObject(
                id: UUID(),
                imageName: ["ic_coin", "ic_pizza"].randomElement() ?? "ic_coin",
                xPosition: CGFloat.random(in: 100...(UIScreen.main.bounds.width - 100)),
                yPosition: 0,
                fallDuration: 7
            )
            fallingObjects.append(newObject)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + newObject.fallDuration) {
                fallingObjects.removeAll { $0.id == newObject.id }
            }
        }
    }
    
    func stopFallingObjects() {
        timer?.invalidate()
        timer = nil
    }
    
    func moveObjectToBottom(_ object: FallingObject) {
        if let index = fallingObjects.firstIndex(where: { $0.id == object.id }) {
            fallingObjects[index].yPosition = UIScreen.main.bounds.height + 15
        }
    }
    
}

#Preview {
    LoadingScreenView()
}
