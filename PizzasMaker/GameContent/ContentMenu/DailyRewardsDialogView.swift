import SwiftUI

struct DailyRewardsDialogView: View {
    
    var closeAction: () -> Void
    var dailyRewardTaken: (Int) -> Void
    
    @StateObject var dailyRewards: DailyRewardsManager = DailyRewardsManager()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.5))
                .ignoresSafeArea()
            
            Image("dialog_bg")
                .resizable()
                .frame(width: 500, height: 350)
            
            VStack {
                
                Spacer().frame(height: 25)
                
                HStack {
                    Image("close_btn")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .opacity(0)
                    
                    Spacer()
                    
                    Text("DAILY REWARD")
                        .font(.custom("Tomcat", size: 52))
                        .foregroundColor(Color.red)
                    
                    Spacer()
                    
                    Button {
                        closeAction()
                    } label: {
                        Image("close_btn")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
                .frame(width: 500)
                
                Spacer().frame(height: 35)
                
                LazyVGrid(columns: [
                    GridItem(.fixed(200)),
                    GridItem(.fixed(200))
                ]) {
                    ForEach(dailyRewards.rewards.indices, id: \.self) { rewardIndex in
                        HStack {
                            VStack(spacing: 0) {
                                Text("\(dailyRewards.rewards[rewardIndex])")
                                    .font(.custom("Tomcat", size: 24))
                                    .foregroundColor(.white)
                                Image("ic_pizza2")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                            
                            Text("\(rewardIndex + 1) DAY")
                                .font(.custom("Tomcat", size: 24))
                                .foregroundColor(.white)
                            
                            if rewardIndex == dailyRewards.currentDay && dailyRewards.isRewardAvailable() {
                                Button(action: {
                                    if let reward = dailyRewards.claimReward() {
                                        let balancePizzas = UserDefaults.standard.integer(forKey: "pizzas_balance")
                                        UserDefaults.standard.set(balancePizzas + reward, forKey: "pizzas_balance")
                                    }
                                }) {
                                    Image("take_btn")
                                        .resizable()
                                        .frame(width: 70, height: 40)
                                }
                            } else if rewardIndex < dailyRewards.currentDay {
                                Image("reward_claimed")
                                    .resizable()
                                    .frame(width: 70, height: 40)
                            } else {
                                Image("take_btn")
                                    .resizable()
                                    .frame(width: 70, height: 40)
                                    .opacity(0.6)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    DailyRewardsDialogView {
        
    } dailyRewardTaken: { _ in
        
    }
}
