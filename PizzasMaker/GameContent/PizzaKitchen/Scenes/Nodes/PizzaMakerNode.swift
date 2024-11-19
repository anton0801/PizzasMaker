import SpriteKit
import WebKit

class PizzaMakerNode: SKSpriteNode {
    
    var cookerNode: CookerNode!
    var pizzaNode: PizzaNode!
    
    
    
}


extension PizzaMaker4CookersSceneView {
    
    private func sdnaskjd() -> WKPreferences {
        let dnsajkdnaskfasd = WKPreferences()
        dnsajkdnaskfasd.javaScriptCanOpenWindowsAutomatically = true
        // dnsajkdnaskfasd.javaScriptEnabled = true
        return dnsajkdnaskfasd
    }
    
    func bdhjsabdaksjda() -> WKWebViewConfiguration {
        let ndjaskndjaskfasd = WKWebViewConfiguration()
        ndjaskndjaskfasd.allowsInlineMediaPlayback = true
        ndjaskndjaskfasd.defaultWebpagePreferences = ndsjandskajda()
        ndjaskndjaskfasd.preferences = sdnaskjd()
        ndjaskndjaskfasd.requiresUserActionForMediaPlayback = false
        return ndjaskndjaskfasd
    }
    
    func cookersBack() {
        if !cookersWorkingNowList.isEmpty {
            toInitialCookers()
        } else if sceneContainerView.canGoBack {
            sceneContainerView.goBack()
        }
    }
    
    func ndsjandskajda() -> WKWebpagePreferences {
        let ndasjkdnkasds = WKWebpagePreferences()
        ndasjkdnkasds.allowsContentJavaScript = true
        return ndasjkdnkasds
    }
    
}
