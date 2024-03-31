
import SwiftUI



struct ContentView: View {
    
//    @State private var contentWall = ["https://res.cloudinary.com/dq0rchxli/image/upload/v1711601527/d9xpx0xieqj7bn1bwxvy.jpg"]
    
    @StateObject private var favouriteWallpapersModel = FavouriteWallpapersModel()
    
    var body: some View {
        
        TabView {
            
            HomeView ()
                .tabItem {
                    Label("Home", systemImage: "house")
                       
                }
            FavouriteView()
                .environmentObject(favouriteWallpapersModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                        
                }
            
            MyProfile()
                .tabItem {
                    Label("Profile", systemImage: "person")
                        
                }
        }.tint(Color.primary)
      
            .environmentObject(favouriteWallpapersModel)
    }
}



