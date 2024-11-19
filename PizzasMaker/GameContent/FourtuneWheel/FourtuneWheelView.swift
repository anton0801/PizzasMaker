import SwiftUI

struct FourtuneWheelView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var alertWin = false
    @State var alertMessage = ""
    
    @EnvironmentObject var bonusAvailabilityManager: BonusAvailabilityManager
    
    @State private var rotationAngle: Double = 0
    @State private var isSpinning: Bool = false {
        didSet {
            if !isSpinning {
                bonusAvailabilityManager.claimBonus()
                let balancePizzas = UserDefaults.standard.integer(forKey: "pizzas_balance")
                UserDefaults.standard.set(balancePizzas + 20, forKey: "pizzas_balance")
                alertMessage = "Congratulations, you've won 20 pizzas!"
                alertWin = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back_to_menu")
                            .resizable()
                            .frame(width: 170, height: 50)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    fortuneWheel
                    Spacer()
                }
            }
        }
        .background(
            Image("fortune_wheel_back")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $alertWin) {
            Alert(title: Text("Alert!"), message: Text(alertMessage), dismissButton: .default(Text("Good!"), action: {
                presMode.wrappedValue.dismiss()
            }))
        }
    }
    
    private var fortuneWheel: some View {
        ZStack {
            Image("fortune_wheel_bg")
                .resizable()
                .frame(width: 450, height: 250)
                .offset(y: 100)
            
            Image("fortune_wheel_r")
                .resizable()
                .frame(width: 400, height: 400)
                .rotationEffect(.degrees(rotationAngle))
                .animation(.easeInOut(duration: 4), value: rotationAngle)
                .offset(y: 200)
            
            Image("fortune_indicator")
                .resizable()
                .frame(width: 52, height: 52)
            
            Button {
                spinWheel()
            } label: {
                Image("fortune_tap")
                    .resizable()
                    .frame(width: 500, height: 120)
            }
            .offset(y: 190)
        }
    }
    
    private func spinWheel() {
        guard !isSpinning else { return }
        isSpinning = true
        
        let newRotation = (rotationAngle + 62.5 * 6) * 5
        
        rotationAngle = newRotation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isSpinning = false
        }
    }
    
}

#Preview {
    FourtuneWheelView()
        .environmentObject(BonusAvailabilityManager())
}
