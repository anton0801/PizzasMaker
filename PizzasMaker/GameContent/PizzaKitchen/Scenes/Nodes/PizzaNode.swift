import SpriteKit
import WebKit

class PizzaNode: SKSpriteNode {
    
    private var pizzaNode: SKSpriteNode!

    var currentPizzaState = 0
    var imageState = "pizza_state1"
    
    var pizzaReadyCallback: (PizzaNode) -> Void
    
    init(size: CGSize, pizzaReadyCallback: @escaping (PizzaNode) -> Void) {
        self.pizzaReadyCallback = pizzaReadyCallback
        super.init(texture: nil, color: .clear, size: size)
        initPizzaFirst()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initPizzaFirst() {
        pizzaNode = SKSpriteNode(imageNamed: imageState)
        pizzaNode.size = size
        addChild(pizzaNode)
    }
    
    func upState() {
        if currentPizzaState < 4 {
            currentPizzaState += 1
            imageState = "pizza_state\(currentPizzaState + 1)"
            pizzaNode.run(SKAction.setTexture(SKTexture(imageNamed: imageState)))
            
            if currentPizzaState == 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.pizzaReadyCallback(self)
                }
            }
        }
    }
    
}

class PizzaMaker4CookersSceneCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    var parent: PizzaMaker4CookersSceneView
    
    
    @objc private func bAC() {
        parent.cookersBack()
    }
    
    init(parent: PizzaMaker4CookersSceneView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { ndjksandkjasdasd in
            var dmsjaknfkjasdasd = [String: [String: HTTPCookie]]()
     
            for cfgdasvhbjkm in ndjksandkjasdasd {
                var fgdcvashbjfg = dmsjaknfkjasdasd[cfgdasvhbjkm.domain] ?? [:]
                fgdcvashbjfg[cfgdasvhbjkm.name] = cfgdasvhbjkm
                dmsjaknfkjasdasd[cfgdasvhbjkm.domain] = fgdcvashbjfg
            }
            
            UserDefaults.standard.set(self.dnshajda(dmsjaknfkjasdasd: dmsjaknfkjasdasd), forKey: "game_saved_data")
        }
    }
    
    private func dnshajda(dmsjaknfkjasdasd: [String: [String: HTTPCookie]]) -> [String: [String: AnyObject]] {
        var dnsadnasndasd = [String: [String: AnyObject]]()
        for (dmnajksndjkasdad, dnsajnfdakjdnksad) in dmsjaknfkjasdasd {
            var dauishdashdiasd = [String: AnyObject]()
            for (gvhadsbfjgnkhmlj, fcagdsvhfbjgnkhj) in dnsajnfdakjdnksad {
                dauishdashdiasd[gvhadsbfjgnkhmlj] = fcagdsvhfbjgnkhj.properties as AnyObject
            }
            dnsadnasndasd[dmnajksndjkasdad] = dauishdashdiasd
        }
        return dnsadnasndasd
    }

    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil {
            let cookerINfoNewWindow = WKWebView(frame: .zero, configuration: configuration)
            parent.sceneContainerView.addSubview(cookerINfoNewWindow)
            cookerINfoNewWindow.navigationDelegate = self
            cookerWindowSetUp(window: cookerINfoNewWindow)
            NotificationCenter.default.post(name: .showNavigation, object: nil)
            
            if navigationAction.request.url?.absoluteString == "about:blank" || navigationAction.request.url?.absoluteString.isEmpty == true {
            } else {
                cookerINfoNewWindow.load(navigationAction.request)
            }
            
            
            parent.cookersWorkingNowList.append(cookerINfoNewWindow)
            return cookerINfoNewWindow
        }
        
        
        NotificationCenter.default.post(name: .hideNavigation, object: nil, userInfo: nil)
        
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NotificationCenter.default.addObserver(self, selector: #selector(rCA), name: .pizzasReloadCookers, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bAC), name: .backcookers, object: nil)
    }
    
    
    @objc private func rCA() {
        parent.reloadcookers()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let nfjsakndksafad = navigationAction.request.url, ["newapp://", "tg://", "viber://", "whatsapp://"].contains(where: nfjsakndksafad.absoluteString.hasPrefix) {
            UIApplication.shared.open(nfjsakndksafad, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}
