
import SwiftUI

struct ContentView: View {
    @State private var favorites: [String] = []
    

    var body: some View {
        TabView {
            HomeView ()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavouriteView(FavouriteList: $favorites)
            
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            MyProfile()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
      
        
    }
}


