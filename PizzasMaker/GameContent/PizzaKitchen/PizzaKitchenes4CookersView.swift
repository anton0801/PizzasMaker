import SwiftUI
import WebKit

struct PizzaKitchenes4CookersView: View {
    @State var visiallnavi = false
    
    private func pushNotif(name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    var body: some View {
        VStack {
            PizzaMaker4CookersSceneView(cookersSkin: URL(string: UserDefaults.standard.string(forKey: "response_client") ?? "")!)
            
            if visiallnavi {
                ZStack {
                    Color.black
                    HStack {
                        Button {
                            pushNotif(name: .backcookers)
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button {
                            pushNotif(name: .pizzasReloadCookers)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(4)
                }
                .frame(height: 62)
            }
        }
        .edgesIgnoringSafeArea([.trailing,.leading])
        .onReceive(NotificationCenter.default.publisher(for: .hideNavigation), perform: { _ in
            withAnimation(.linear(duration: 0.4)) {
                visiallnavi = false
            }
        })
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: .showNavigation), perform: { _ in
            withAnimation(.linear(duration: 0.4)) {
                visiallnavi = true
            }
        })
    }
}

extension Notification.Name {
    static let hideNavigation = Notification.Name("hide_navigation")
    static let backcookers = Notification.Name("runner_back")
    static let showNavigation = Notification.Name("show_navigation")
    static let pizzasReloadCookers = Notification.Name("reload_runner")
}

#Preview {
    PizzaKitchenes4CookersView()
}

struct CookerSkins {
    var savedSkins: [String: [String: [HTTPCookiePropertyKey: AnyObject]]]?
}


