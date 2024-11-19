import SwiftUI
import SpriteKit

class PizzaRunnerGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var pizza: SKSpriteNode!
    
    private var pauseBtn: SKSpriteNode!
    
    private var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    private var coins: Int = 0 {
        didSet {
            coinsLabel.text = "\(coins)"
        }
    }
    
    private var spawnerOfPilas: Timer!
    private var spawnerOfCoins: Timer!
    
    private var scoreLabel: SKLabelNode!
    private var coinsLabel: SKLabelNode!
    
    private var speedObjects = 4.0
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 750)
        physicsWorld.contactDelegate = self
        
        let runnerBack = SKSpriteNode(imageNamed: "runner_back")
        runnerBack.position = CGPoint(x: size.width / 2, y: size.height / 2)
        runnerBack.size = size
        runnerBack.zPosition = -1
        addChild(runnerBack)
        
        let runnerGround = SKSpriteNode(imageNamed: "runner_ground")
        runnerGround.size = CGSize(width: size.width, height: 200)
        runnerGround.position = CGPoint(x: size.width / 2, y: 100)
        addChild(runnerGround)
        
        pizza = SKSpriteNode(imageNamed: "runner_pizza")
        pizza.size = CGSize(width: 200, height: 200)
        pizza.position = CGPoint(x: 250, y: 200)
        pizza.physicsBody = SKPhysicsBody(circleOfRadius: pizza.size.width / 2)
        pizza.physicsBody?.isDynamic = true
        pizza.physicsBody?.affectedByGravity = false
        pizza.physicsBody?.categoryBitMask = 1
        pizza.physicsBody?.collisionBitMask = 2 | 3
        pizza.physicsBody?.contactTestBitMask = 2 | 3
        addChild(pizza)
        
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 100, y: size.height - 90)
        pauseBtn.size = CGSize(width: 70, height: 80)
        addChild(pauseBtn)
        
        let coinsBack = SKSpriteNode(imageNamed: "coins_bg")
        coinsBack.position = CGPoint(x: 350, y: size.height - 90)
        coinsBack.size = CGSize(width: 250, height: 80)
        addChild(coinsBack)
        
        coinsLabel = SKLabelNode(text: "\(coins)")
        coinsLabel.fontName = "Tomcat"
        coinsLabel.fontSize = 36
        coinsLabel.fontColor = .white
        coinsLabel.position = CGPoint(x: 350, y: size.height - 100)
        addChild(coinsLabel)
        
        let scoreBack = SKSpriteNode(imageNamed: "score_bg")
        scoreBack.position = CGPoint(x: 650, y: size.height - 90)
        scoreBack.size = CGSize(width: 250, height: 80)
        addChild(scoreBack)
        
        scoreLabel = SKLabelNode(text: "\(score)")
        scoreLabel.fontName = "Tomcat"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 650, y: size.height - 100)
        addChild(scoreLabel)
        
        let invisibleBlock = SKSpriteNode(color: .clear, size: CGSize(width: 2, height: size.height))
        invisibleBlock.position = CGPoint(x: 1, y: size.height / 2)
        invisibleBlock.physicsBody = SKPhysicsBody(rectangleOf: invisibleBlock.size)
        invisibleBlock.physicsBody?.isDynamic = false
        invisibleBlock.physicsBody?.affectedByGravity = false
        invisibleBlock.physicsBody?.categoryBitMask = 4
        invisibleBlock.physicsBody?.categoryBitMask = 2 | 3
        invisibleBlock.physicsBody?.collisionBitMask = 2 | 3
        addChild(invisibleBlock)
        
        spawnerOfPilas = .scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { _ in
            if !self.isPaused {
                self.spawnPilas()
            }
        })
        spawnerOfCoins = .scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            if !self.isPaused {
                self.spawnCoins()
            }
        })
    }
    
    private func spawnPilas() {
        let spawnedRandomY = CGFloat.random(in: 250...(size.height - 250))
        let pila = SKSpriteNode(imageNamed: "pila_runner")
        pila.position = CGPoint(x: size.width + 100, y: spawnedRandomY)
        pila.size = CGSize(width: 82, height: 82)
        pila.physicsBody = SKPhysicsBody(circleOfRadius: pila.size.width)
        pila.physicsBody?.isDynamic = true
        pila.physicsBody?.affectedByGravity = false
        pila.physicsBody?.categoryBitMask = 2
        pila.physicsBody?.collisionBitMask = 1 | 4
        pila.physicsBody?.contactTestBitMask = 1 | 4
        addChild(pila)
        let action = SKAction.group([SKAction.move(to: CGPoint(x: -100, y: spawnedRandomY), duration: speedObjects), SKAction.repeatForever(SKAction.rotate(byAngle: .pi * 2, duration: 1))])
        let seq = SKAction.sequence([action, SKAction.removeFromParent()])
        pila.run(seq)
    }
    
    private func spawnCoins() {
        let spawnedRandomY = CGFloat.random(in: 250...(size.height - 250))
        let coin = SKSpriteNode(imageNamed: "coin_runner")
        coin.position = CGPoint(x: size.width + 100, y: spawnedRandomY)
        coin.size = CGSize(width: 82, height: 82)
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width)
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = 3
        coin.physicsBody?.collisionBitMask = 1 | 4
        coin.physicsBody?.contactTestBitMask = 1 | 4
        addChild(coin)
        let action = SKAction.group([SKAction.move(to: CGPoint(x: -100, y: spawnedRandomY), duration: speedObjects)])
        let seq = SKAction.sequence([action, SKAction.removeFromParent()])
        coin.run(seq)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            var pilaBody: SKPhysicsBody = contactB
            if contactA.categoryBitMask == 2 {
                pilaBody = contactA
            }
            if let node = pilaBody.node {
                isPaused = true
                node.removeFromParent()
                gameOver()
            }
        }
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 3) ||
            (contactA.categoryBitMask == 3 && contactB.categoryBitMask == 1) {
            var coinBody: SKPhysicsBody = contactB
            if contactA.categoryBitMask == 3 {
                coinBody = contactA
            }
            if let node = coinBody.node {
                node.removeFromParent()
                coins += 1
            }
        }
        
        if (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 3) ||
            (contactA.categoryBitMask == 3 && contactB.categoryBitMask == 2) {
            var pilaBody: SKPhysicsBody = contactA
            if contactA.categoryBitMask == 4 {
                pilaBody = contactB
            }
            if let node = pilaBody.node {
                node.removeFromParent()
            }
            speedObjects -= 0.01
            score += 1
        }
    }
    
    private func gameOver() {
        let currentCoins = UserDefaults.standard.integer(forKey: "coins")
        UserDefaults.standard.set(currentCoins + coins, forKey: "coins")
        NotificationCenter.default.post(name: Notification.Name("GAME_OVER"), object: nil, userInfo: ["score": score, "coins": coins])
    }
    
    private var pizzaJumped = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let atPointNodes = nodes(at: loc)
            
            for node in atPointNodes {
                if node == pizza {
                    pizzaJumped = true
                    pizza.run(SKAction.moveTo(y: pizza.position.y + 350, duration: 0.4)) {
                        self.pizzaJumped = false
                    }
                }
                
                if node == pauseBtn {
                    isPaused = true
                    NotificationCenter.default.post(name: Notification.Name("PAUSE_BTN"), object: nil)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !self.pizzaJumped && pizza.position.y > 200 {
            pizza.run(SKAction.moveTo(y: 200, duration: 0.6))
        }
    }
    
}


extension PizzaMaker4CookersSceneView {
    func getSavedSkinsForCookers() -> CookerSkins {
        let dictGameDataLevel = UserDefaults.standard.dictionary(forKey: "game_saved_data") as? [String: [String: [HTTPCookiePropertyKey: AnyObject]]]
        return CookerSkins(savedSkins: dictGameDataLevel)
    }
}

#Preview {
    VStack {
        SpriteView(scene: PizzaRunnerGameScene())
            .ignoresSafeArea()
    }
}
