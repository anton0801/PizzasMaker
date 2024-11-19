import SpriteKit
import WebKit

class CookerNode: SKSpriteNode {
    
    private var cookerNode: SKSpriteNode!
    private var cookerHands: SKSpriteNode!
    
    init(size: CGSize) {
        cookerNode = SKSpriteNode(imageNamed: "cooker")
        cookerNode.size = size
        cookerHands = SKSpriteNode(imageNamed: "cooker_hands")
        cookerHands.size = size
        cookerHands.zPosition = 10
        super.init(texture: nil, color: .clear, size: size)
        addChild(cookerNode)
        addChild(cookerHands)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension PizzaMaker4CookersSceneCoordinator {
    func cookerWindowSetUp(window: WKWebView) {
        window.translatesAutoresizingMaskIntoConstraints = false
        window.scrollView.isScrollEnabled = true
        window.allowsBackForwardNavigationGestures = true
        window.uiDelegate = self
        NSLayoutConstraint.activate([
            window.topAnchor.constraint(equalTo: parent.sceneContainerView.topAnchor),
            window.bottomAnchor.constraint(equalTo: parent.sceneContainerView.bottomAnchor),
            window.leadingAnchor.constraint(equalTo: parent.sceneContainerView.leadingAnchor),
            window.trailingAnchor.constraint(equalTo: parent.sceneContainerView.trailingAnchor)
        ])

    }
}
