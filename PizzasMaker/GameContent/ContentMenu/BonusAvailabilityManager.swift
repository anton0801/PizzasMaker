import SwiftUI

class BonusAvailabilityManager: ObservableObject {
    @Published private(set) var isBonusAvailable: Bool = false
    private let lastBonusKey = "LastBonusClaimDate"
    private let bonusCooldown: TimeInterval = 24 * 60 * 60 // 24 часа в секундах
    
    init() {
        checkBonusAvailability()
    }
    
    /// Метод для проверки доступности бонуса
    func checkBonusAvailability() {
        let now = Date()
        if let lastBonusDate = UserDefaults.standard.object(forKey: lastBonusKey) as? Date {
            // Проверяем, прошло ли 24 часа с последнего получения бонуса
            isBonusAvailable = now.timeIntervalSince(lastBonusDate) >= bonusCooldown
        } else {
            // Если бонус никогда не брался, он доступен
            isBonusAvailable = true
        }
    }
    
    /// Метод для получения бонуса
    func claimBonus() {
        guard isBonusAvailable else { return }
        // Устанавливаем текущее время как время получения бонуса
        UserDefaults.standard.set(Date(), forKey: lastBonusKey)
        isBonusAvailable = false
    }
}
