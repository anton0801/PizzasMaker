import Foundation
import WebKit

struct DailyRewardItem: Codable {
    var day: Int
    var reward: Int
    var item: String
    var status: String
}

struct DailyRewardsResponse: Codable {
    var dailyRewards: [DailyRewardItem]
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case dailyRewards = "daily_rewards"
        case status = "response"
    }
}

struct SecondsDataRewards: Codable {
    var useruid: String
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case useruid = "client_id"
        case status = "response"
    }
}

class LoadingSplashVm: ObservableObject {
    
    @Published var hasComePushToken = false
    
    init() {
        timeouttimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerSecPassed), userInfo: nil, repeats: true)
    }
    
    @objc private func timerSecPassed() {
        loadingPassed += 1
    }
    
    func startObtainingDailyRewardsAndSaveIt() {
        if dsmnakndasjkdnak() {
            getDailyRewardsFirstDays()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.kitchenGamReady()
            }
        }
    }
    
    @Published var loadingPassed = 0 {
        didSet {
            if loadingPassed == 5 {
                if !hasComePushToken {
                    if !bdsahjdbsa {
                        startObtainingDailyRewardsAndSaveIt()
                        bdsahjdbsa = true
                    }
                }
                timeouttimer.invalidate()
            }
        }
    }
    
    @Published var loadedGAme = false
    
    private func getDailyRewardsFirstDays() {
        bdsahjdbsa = true
        guard let dailyRewardsEnd = URL(string: "https://pinkycook.store/game-api") else { return }
        URLSession.shared.dataTask(with: getGameItemsRef(dailyRewardsEnd)) { data, response, error in
            if let _ = error {
                self.kitchenGamReady()
                return
            }
            
            guard let data = data else {
                self.kitchenGamReady()
                return
            }
            
            do {
                let dailyRewardsResponse = try JSONDecoder().decode(DailyRewardsResponse.self, from: data)
                if dailyRewardsResponse.status == nil {
                    self.operateDailyRewards(rewards: dailyRewardsResponse.dailyRewards)
                    self.kitchenGamReady()
                } else {
                    self.loadOtherSecondsDailyRewards(dailyRewardsResponse.status!)
                }
            } catch {
                self.kitchenGamReady()
            }
        }.resume()
        
    }
    
    private var timeouttimer = Timer()
    
    private func operateDailyRewards(rewards: [DailyRewardItem]) {
        do {
            UserDefaults.standard.set(try JSONEncoder().encode(rewards), forKey: "rewards_data")
        } catch {
            
        }
    }
    
    private func loadOtherSecondsDailyRewards(_ secondsdrli: String) {
        if UserDefaults.standard.bool(forKey: "sdafa") {
            kitchenGamReady()
            return
        }
        
        
        if let rewardsInGame = URL(string: dnsjkadasfsad(base: secondsdrli)) {
            var dailyRewardsReqe = URLRequest(url: rewardsInGame)
            dailyRewardsReqe.addValue("application/json", forHTTPHeaderField: "Content-Type")
            dailyRewardsReqe.addValue(ndsjakda, forHTTPHeaderField: "User-Agent")
            dailyRewardsReqe.httpMethod = "POST"
            URLSession.shared.dataTask(with: dailyRewardsReqe) { data, response, error in
                if let _ = error {
                    self.kitchenGamReady()
                    return
                }
                
                guard let data = data else {
                    self.kitchenGamReady()
                    return
                }
                
                do {
                    self.dailyRewardsAllReceived(try JSONDecoder().decode(SecondsDataRewards.self, from: data))
                } catch {
                    self.kitchenGamReady()
                }
            }.resume()
        }
    }
    
    var ndsjakda = WKWebView().value(forKey: "userAgent") as? String ?? ""
    
    private func dailyRewardsAllReceived(_ secondsData: SecondsDataRewards) {
        UserDefaults.standard.set(secondsData.useruid, forKey: "client_id")
        if let dailyRewards = secondsData.status {
            UserDefaults.standard.set(dailyRewards, forKey: "response_client")
            self.kitchenGamReady { self.status = dailyRewards }
        } else {
            UserDefaults.standard.set(true, forKey: "sdafa")
            self.kitchenGamReady()
        }
    }
    
    @Published var status: String? = nil
    @Published var bdsahjdbsa = false
    
    
}

extension LoadingSplashVm {
    
    
    func getUserId() -> String {
        var userUUID = UserDefaults.standard.string(forKey: "client-uuid") ?? ""
        if userUUID.isEmpty {
            userUUID = UUID().uuidString
            UserDefaults.standard.set(userUUID, forKey: "client-uuid")
        }
        return userUUID
    }
    
    func kitchenGamReady(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.loadedGAme = true
            completion?()
        }
    }
    
    func getGameItemsRef(_ e: URL) -> URLRequest {
        var gamesRef = URLRequest(url: e)
        gamesRef.httpMethod = "GET"
        gamesRef.addValue(getUserId(), forHTTPHeaderField: "client-uuid")
        return gamesRef
    }
    
}
