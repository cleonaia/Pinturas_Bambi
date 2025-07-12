import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            
            ProductsView()
                .tabItem {
                    Image(systemName: "paintbrush.fill")
                    Text("Productos")
                }
            
            ColorMatcherView()
                .tabItem {
                    Image(systemName: "eyedropper.halffull")
                    Text("Colores")
                }
            
            CalculatorView()
                .tabItem {
                    Image(systemName: "calculator")
                    Text("Calculadora")
                }
            
            StoreLocatorView()
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("Tiendas")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
        }
        .accentColor(Color(PinturasBambiTheme.primaryColor))
    }
}

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let homeVC = UIHostingController(rootView: HomeView())
        homeVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let productsVC = UIHostingController(rootView: ProductsView())
        productsVC.tabBarItem = UITabBarItem(title: "Productos", image: UIImage(systemName: "paintbrush.fill"), tag: 1)
        
        let colorsVC = UIHostingController(rootView: ColorMatcherView())
        colorsVC.tabBarItem = UITabBarItem(title: "Colores", image: UIImage(systemName: "eyedropper.halffull"), tag: 2)
        
        let calculatorVC = UIHostingController(rootView: CalculatorView())
        calculatorVC.tabBarItem = UITabBarItem(title: "Calculadora", image: UIImage(systemName: "calculator"), tag: 3)
        
        let storeVC = UIHostingController(rootView: StoreLocatorView())
        storeVC.tabBarItem = UITabBarItem(title: "Tiendas", image: UIImage(systemName: "location.fill"), tag: 4)
        
        let profileVC = UIHostingController(rootView: ProfileView())
        profileVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person.fill"), tag: 5)
        
        viewControllers = [homeVC, productsVC, colorsVC, calculatorVC, storeVC, profileVC]
    }
}

#Preview {
    ContentView()
}
