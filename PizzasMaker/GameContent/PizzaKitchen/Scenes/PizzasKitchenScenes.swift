import SwiftUI
import SpriteKit

class PizzasKitchesScenes: SKScene {
    
    private var pauseBtn: SKSpriteNode!
    
    private var cookersMax = 2
    private var cookersCount: Int = UserDefaults.standard.integer(forKey: "cookers_count") {
        didSet {
            cookersCountLabel.text = "\(cookersCount)/\(cookersMax)"
        }
    }
    private var coins: Int = 0 {
        didSet {
            coinsLabel.text = "\(coins)"
        }
    }
    private var pizzasCount: Int = 0 {
        didSet {
            pizzasCountLabel.text = "\(pizzasCount)/\(objectiveOfPizzas)"
            if pizzasCount == objectiveOfPizzas {
                gameTimer.invalidate()
                let currentLevel = UserDefaults.standard.integer(forKey: "level_passed_kitchen")
                UserDefaults.standard.set(currentLevel + 1, forKey: "level_passed_kitchen")
                gameWin()
            }
        }
    }
    private var cookersCountLabel: SKLabelNode!
    private var coinsLabel: SKLabelNode!
    private var pizzasCountLabel: SKLabelNode!
    
    private var objectiveOfPizzas = 25
    
    private var table: SKSpriteNode!
    private var pizzasIcon: SKSpriteNode!
    
    private var lockNode: SKSpriteNode!
    
    private var cookers: [String: CookerNode] = [:]
    private var pizzas: [String: PizzaNode] = [:]
    
    var gameTimer: Timer!
    var makingTime = 0
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 750)
        
        objectiveOfPizzas = (5 * UserDefaults.standard.integer(forKey: "level_passed_kitchen")) + 20
        
        let kitchenBackground = SKSpriteNode(imageNamed: "kitchen_bg")
        kitchenBackground.size = size
        kitchenBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(kitchenBackground)
        
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 100, y: size.height - 90)
        pauseBtn.size = CGSize(width: 70, height: 80)
        addChild(pauseBtn)
        
        let kitchenInfoBack = SKSpriteNode(imageNamed: "kitchen_info_bg")
        kitchenInfoBack.position = CGPoint(x: size.width / 2, y: size.height - 100)
        kitchenInfoBack.size = CGSize(width: 700, height: 100)
        addChild(kitchenInfoBack)
        
        let coinsBack = SKSpriteNode(imageNamed: "coins_bg")
        coinsBack.position = CGPoint(x: size.width / 2, y: size.height - 90)
        coinsBack.size = CGSize(width: 250, height: 80)
        addChild(coinsBack)
        
        coinsLabel = SKLabelNode(text: "\(coins)")
        coinsLabel.fontName = "Tomcat"
        coinsLabel.fontSize = 36
        coinsLabel.fontColor = .white
        coinsLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(coinsLabel)
        
        cookersCountLabel = SKLabelNode(text: "\(cookersCount)/\(cookersMax)")
        cookersCountLabel.fontName = "Tomcat"
        cookersCountLabel.fontSize = 36
        cookersCountLabel.fontColor = .white
        cookersCountLabel.position = CGPoint(x: size.width / 2 + (kitchenInfoBack.size.width / 2) - 60, y: size.height - 110)
        addChild(cookersCountLabel)
        
        let cookersIcon = SKSpriteNode(imageNamed: "cooker_icon")
        cookersIcon.size = CGSize(width: 82, height: 120)
        cookersIcon.position = CGPoint(x: size.width / 2 + (kitchenInfoBack.size.width / 2) + 20, y: size.height - 100)
        addChild(cookersIcon)
        
        pizzasIcon = SKSpriteNode(imageNamed: "pizza_7")
        pizzasIcon.size = CGSize(width: 80, height: 80)
        pizzasIcon.position = CGPoint(x: size.width / 2 - (kitchenInfoBack.size.width / 2) - 30, y: size.height - 100)
        addChild(pizzasIcon)
        
        pizzasCountLabel = SKLabelNode(text: "\(pizzasCount)/\(objectiveOfPizzas)")
        pizzasCountLabel.fontName = "Tomcat"
        pizzasCountLabel.fontSize = 36
        pizzasCountLabel.fontColor = .white
        pizzasCountLabel.position = CGPoint(x: size.width / 2 - (kitchenInfoBack.size.width / 2) + 60, y: size.height - 110)
        addChild(pizzasCountLabel)
        
        let startXCookers = size.width / 2 - 180
        for i in 0..<cookersCount {
            addCooker(tablePos: i)
        }
        
        table = SKSpriteNode(imageNamed: "table")
        table.position = CGPoint(x: size.width / 2, y: 200)
        table.size = CGSize(width: 1000, height: 450)
        addChild(table)
        
        spawnPizzas()
        
        if cookersCount == 1 {
            let lockPosition = CGPoint(x: startXCookers + (CGFloat(2) * 170), y: 300)
            lockNode = SKSpriteNode()
            lockNode.position = lockPosition
            
            let price = SKSpriteNode(imageNamed: "price_99_pizzas")
            price.size = CGSize(width: 110, height: 60)
            price.position = CGPoint(x: 0, y: 140)
            lockNode.addChild(price)
            
            let lock = SKSpriteNode(imageNamed: "lock")
            lock.size = CGSize(width: 120, height: 180)
            lockNode.addChild(lock)
            
            let plusBtn = SKSpriteNode(imageNamed: "plus_btn")
            plusBtn.size = CGSize(width: 42, height: 42)
            plusBtn.position = CGPoint(x: 0, y: -130)
            lockNode.addChild(plusBtn)
            
            addChild(lockNode)
        }
        
        gameTimer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if !self.isPaused {
                self.makingTime += 1
            }
        })
    }
    
    private func addCooker(tablePos: Int) {
        let startXCookers = size.width / 2 - 180
        let cooker = CookerNode(size: CGSize(width: 350, height: 400))
        cooker.position = CGPoint(x: startXCookers + (CGFloat(tablePos) * 330), y: 270)
        cooker.name = "cooker_\(tablePos)"
        addChild(cooker)
        cookers[cooker.name!] = cooker
    }
    
    private func spawnPizzas() {
        let startXPizzas = size.width / 2 - 180
        for i in 0..<cookersCount {
            let pizzaNode = PizzaNode(size: CGSize(width: 110, height: 110)) { pizza in
                self.pizzaMade(pizzaNode: pizza, cookerName: "cooker_\(i)")
            }
            pizzaNode.name = "pizza_\(UUID().uuidString)"
            pizzaNode.position = CGPoint(x: startXPizzas + (CGFloat(i) * 330), y: 150)
            pizzaNode.zPosition = 7
            pizzas["cooker_\(i)"] = pizzaNode
            addChild(pizzaNode)
        }
    }
    
    private func pizzaMade(pizzaNode: PizzaNode, cookerName: String) {
        pizzasCount += 1
        
        let newPizzaNode = PizzaNode(size: CGSize(width: 110, height: 110)) { pizza in
            self.pizzaMade(pizzaNode: pizza, cookerName: cookerName)
        }
        newPizzaNode.name = "pizza_\(UUID().uuidString)"
        newPizzaNode.position = pizzaNode.position
        newPizzaNode.zPosition = 7
        pizzas[cookerName] = newPizzaNode
        addChild(newPizzaNode)
        let actionMove = SKAction.move(to: pizzasIcon.position, duration: 0.7)
        let actionScale = SKAction.scale(to: 0.725, duration: 0.7)
        let group = SKAction.group([actionMove, actionScale])
        let seq = SKAction.sequence([group, SKAction.removeFromParent()])
        pizzaNode.run(seq)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let objectNodes = nodes(at: touch.location(in: self))
            for n in objectNodes {
                if n.name?.contains("cooker") == true {
                    let idCooker = n.name!
                    let pizzaNode = pizzas[idCooker]
                    if let pizzaNode = pizzaNode {
                        pizzaNode.upState()
                    }
                }
                
                if n == lockNode {
                    addCooker(tablePos: 1)
                    lockNode.removeFromParent()
                    UserDefaults.standard.set(2, forKey: "cookers_count")
                }
                
                if n == pauseBtn {
                    isPaused = true
                    NotificationCenter.default.post(name: Notification.Name("PAUSE_BTN"), object: nil)
                }
            }
        }
    }
    
    private func gameWin() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("GAME_WIN"), object: nil, userInfo: ["pizzas": pizzasCount, "time": makingTime])
    }
    
    func restartGameScene() -> PizzasKitchesScenes {
        let newKitchenScene = PizzasKitchesScenes()
        view?.presentScene(newKitchenScene)
        return newKitchenScene
    }
    
}

func dsmnakndasjkdnak() -> Bool {
    let curdat = Date()
    let ndsajkdna = Calendar.current
    var ndsajkdnka = DateComponents()
    ndsajkdnka.year = 2024
    ndsajkdnka.month = 11
    ndsajkdnka.day = 22
    if let targetDate = ndsajkdna.date(from: ndsajkdnka) {
        return curdat >= targetDate
    }
    return false
}

#Preview {
    VStack {
        SpriteView(scene: PizzasKitchesScenes())
            .ignoresSafeArea()
    }
}
