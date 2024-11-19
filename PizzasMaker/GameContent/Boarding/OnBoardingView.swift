import SwiftUI

struct OnBoardingView: View {
    
    @State private var fallingObjects: [FallingObject] = []
    @State private var timer: Timer? = nil
    
    @State var currentBoardingItem = 0 {
        didSet {
            if currentBoardingItem == 1 {
                stopFallingObjects()
            }
            withAnimation(.easeInOut) {
                currentDialog = "dialog_\(currentBoardingItem + 1)"
            }
        }
    }
    @State var currentDialog = "dialog_1"
    @State var passed = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if currentBoardingItem == 0 {
                    Image("loading_background")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
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
                        Button {
                            currentBoardingItem += 1
                        } label: {
                            Image(currentDialog)
                                .resizable()
                                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                                .ignoresSafeArea()
                        }
                    }
                } else {
                    Button {
                        if currentBoardingItem < 3 {
                            currentBoardingItem += 1
                        } else {
                            UserDefaults.standard.set(true, forKey: "onb_pas")
                            passed = true
                        }
                    } label: {
                        Image(currentDialog)
                            .resizable()
                            .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                            .ignoresSafeArea()
                    }
                }
                
                NavigationLink(destination: ContentView()
                    .navigationBarBackButtonHidden(), isActive: $passed) {

                    }
            }
            .onAppear {
                startFallingObjects()
            }
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
    OnBoardingView()
}
