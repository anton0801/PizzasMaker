import SwiftUI

struct GameSelectionMenu: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var commingSoonTowerVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: 42) {
                        NavigationLink(destination: PizzaRunnerGameView()
                            .navigationBarBackButtonHidden()) {
                            Image("pizza_run")
                                .resizable()
                                .frame(width: 200, height: 200)
                        }
                        
                        NavigationLink(destination: PizzaKitchenGameView()
                            .navigationBarBackButtonHidden()) {
                            Image("pizza_kitchen")
                                .resizable()
                                .frame(width: 260, height: 220)
                        }
                        .offset(y: -42)
                        
                        Button {
                            commingSoonTowerVisible.toggle()
                        } label: {
                            Image("tower_pizza")
                                .resizable()
                                .frame(width: 200, height: 200)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 60)
                }
                
                VStack {
                    Spacer()
                    Spacer()
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back_to_menu")
                            .resizable()
                            .frame(width: 170, height: 50)
                    }
                    .padding(.top, 52)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Image("choose_game")
                        .resizable()
                        .frame(width: 500, height: 100)
                }
            }
            .onAppear {
                if UserDefaults.standard.integer(forKey: "cookers_count") == 0 {
                    UserDefaults.standard.set(1, forKey: "cookers_count")
                }
            }
            .background(
                Image("game_menu_back")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height + 20)
                    .ignoresSafeArea()
            )
            .alert(isPresented: $commingSoonTowerVisible) {
                Alert(title: Text("Alert!"), message: Text("Pizza Tower game will be available soon, but for now wait and save your patience because it will be the best game ever!"), dismissButton: .default(Text("I'll be waiting")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GameSelectionMenu()
}
