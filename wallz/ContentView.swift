
import SwiftUI



struct ContentView: View {
    
     @State public var favoritesWallpaper : [String] = []
    
    var body: some View {
        
        TabView {
            
            HomeView ()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavouriteView()
            
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


