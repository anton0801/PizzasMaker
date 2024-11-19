import Foundation

class DailyRewardsManager: ObservableObject {
    @Published private(set) var rewards = [10, 30, 50, 70, 90, 150]
    @Published private(set) var currentDay: Int = 0
    private let lastBonusKey = "lastBonusDate"
    private let currentDayKey = "currentBonusDay"
    
    init() {
        loadState()
    }
    
    func isRewardAvailable() -> Bool {
        guard let lastBonusDate = UserDefaults.standard.object(forKey: lastBonusKey) as? Date else {
            return true
        }
        
        let calendar = Calendar.current
        if let daysSinceLastBonus = calendar.dateComponents([.day], from: lastBonusDate, to: Date()).day, daysSinceLastBonus >= 1 {
            return true
        }
        return false
    }
    
    func claimReward() -> Int? {
        guard isRewardAvailable() else {
            return nil
        }
        
        let reward = rewards[currentDay]
        currentDay = (currentDay + 1) % rewards.count
        saveState()
        return reward
    }
    
    private func saveState() {
        UserDefaults.standard.set(Date(), forKey: lastBonusKey)
        UserDefaults.standard.set(currentDay, forKey: currentDayKey)
    }
    
    private func loadState() {
        if let savedDay = UserDefaults.standard.object(forKey: currentDayKey) as? Int {
            currentDay = savedDay
        }
    }
}
