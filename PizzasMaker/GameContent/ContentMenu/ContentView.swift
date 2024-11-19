import SwiftUI

struct ContentView: View {
    
    @State var dailyRewardVisible: Bool = false
    @State var goToBonus: Bool = false
    
    @State var alertVisible = false
    @State var alertMessage = ""
    
    @StateObject var bonusAvailabilityManager = BonusAvailabilityManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Image("pinkitchen")
                        .resizable()
                        .frame(width: 350, height: 120)
                    
                    NavigationLink(destination: GameSelectionMenu()
                        .navigationBarBackButtonHidden()) {
                        Image("play_btn")
                            .resizable()
                            .frame(width: 200, height: 70)
                    }
                    Button {
                        withAnimation(.linear) {
                            dailyRewardVisible = true
                        }
                    } label: {
                        Image("daily_reward")
                            .resizable()
                            .frame(width: 170, height: 70)
                    }
                    .padding(.leading)
                    
                    Button {
                        if bonusAvailabilityManager.isBonusAvailable {
                            goToBonus = true
                        } else {
                            alertMessage = "The new bonus will be available 24 hours after the last bonus has been used!"
                            alertVisible = true
                        }
                    } label: {
                        Image("fortune_wheel")
                            .resizable()
                            .frame(width: 150, height: 70)
                    }
                    .padding(.leading, 28)
                    
                    NavigationLink(destination: FourtuneWheelView()
                        .environmentObject(bonusAvailabilityManager)
                        .navigationBarBackButtonHidden(), isActive: $goToBonus) {
                        
                    }
                    
                    HStack {
                        Spacer()
                    }
                }
                
                if dailyRewardVisible {
                    DailyRewardsDialogView {
                        withAnimation(.linear) {
                            dailyRewardVisible = false
                        }
                    } dailyRewardTaken: { pizzas in
                        
                    }
                }
            }
            .background(
                Image("content_view_bg")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height + 20)
                    .ignoresSafeArea()
            )
            .alert(isPresented: $alertVisible) {
                Alert(title: Text("Alert!"), message: Text(alertMessage), dismissButton: .default(Text("Good!")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
