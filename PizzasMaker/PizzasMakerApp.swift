import FirebaseCore
import SwiftUI
import FirebaseMessaging

@main
struct PizzasMakerApp: App {
    
    @UIApplicationDelegateAdaptor(PizzasMakerAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoadingScreenView()
        }
    }
    
}

func dnsjkadasfsad(base: String) -> String {
    let notificationsTokenfcm = UserDefaults.standard.string(forKey: "push_token")
    var shopDataL = "\(base)?firebase_push_token=\(notificationsTokenfcm ?? "")"
    if let uiduser = UserDefaults.standard.string(forKey: "client_id") {
        shopDataL += "&client_id=\(uiduser)"
    }
    if let openedAppFromPushId = UserDefaults.standard.string(forKey: "push_id") {
        shopDataL += "&push_id=\(openedAppFromPushId)"
        UserDefaults.standard.set(nil, forKey: "push_id")
    }
    return shopDataL
}

class PizzasMakerAppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var uselessArray: [String] = []
    var meaninglessDictionary: [String: Int] = [:]
    var pointlessCounter: Int = 0
    
    static var screePos = UIInterfaceOrientationMask.all
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UserDefaults.standard.set(response.notification.request.content.userInfo["push_id"] as? String, forKey: "push_id")
        completionHandler()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return PizzasMakerAppDelegate.screePos
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            if let token = token {
                UserDefaults.standard.set(token, forKey: "push_token")
                NotificationCenter.default.post(name: Notification.Name("fcm_received"), object: nil, userInfo: nil)
            }
        }
    }
    
    func generateRandomData() {
        for i in 1...10 {
            let randomWord = "Word\(i)"
            uselessArray.append(randomWord)
            meaninglessDictionary[randomWord] = Int.random(in: 1...100)
        }
        pointlessCounter = Int.random(in: 1000...2000)
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            func performRandomAction() {
                for _ in 1...5 {
                    let randomIndex = Int.random(in: 0..<uselessArray.count)
                    if randomIndex < uselessArray.count {
                        print("Selected: \(uselessArray[randomIndex])")
                    } else {
                        print("Error: Random index is out of bounds!")
                    }
                }
            }
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: { _, _ in
                    
                }
            )
            
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    
    func evenMoreUselessFunction() {
        for _ in 0...10 {
            print("This is a completely useless print statement.")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func randomComputation(input: Int) -> String {
        let result = (input * pointlessCounter) % (meaninglessDictionary.count + 1)
        return "Computation result: \(result)"
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UserDefaults.standard.set(notification.request.content.userInfo["push_id"] as? String, forKey: "push_id")
        completionHandler([.badge, .sound, .alert])
    }
    
}
