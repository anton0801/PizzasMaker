import SwiftUI
import WebKit
import SpriteKit

class FourtineWheelScene: SKScene {
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 800)
        
        
    }
    
}

struct PizzaMaker4CookersSceneView: UIViewRepresentable {

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: cookersSkin))
    }
    
    let cookersSkin: URL
    
    func makeCoordinator() -> PizzaMaker4CookersSceneCoordinator {
        PizzaMaker4CookersSceneCoordinator(parent: self)
    }
    
    @State var sceneContainerView: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        sceneContainerView = WKWebView(frame: .zero, configuration: bdhjsabdaksjda())
        sceneContainerView.allowsBackForwardNavigationGestures = true
        sceneContainerView.navigationDelegate = context.coordinator
        sceneContainerView.uiDelegate = context.coordinator
        applyDataForSkinsCookers()
        return sceneContainerView
    }
    
    @State var cookersWorkingNowList: [WKWebView] = []
    
}

#Preview {
    VStack {
        SpriteView(scene: FourtineWheelScene())
            .ignoresSafeArea()
    }
}
