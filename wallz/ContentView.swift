
import SwiftUI



struct ContentView: View {
    
    
    @StateObject private var favouriteWallpapersModel = FavouriteWallpapersModel()
    
    var body: some View {
        
        TabView {
            
            HomeView ()
                .tabItem {
                    Label("Popular", systemImage: "flame.circle.fill")
                    
                       
                }
            
            
                        Categories()
                .tabItem {
                    Label("Categories", systemImage: "square.stack.3d.up.fill")
                    
                }
            
            FavouriteView()
                .environmentObject(favouriteWallpapersModel)
                .tabItem {
                    Label("Liked",systemImage: "hand.thumbsup.fill")
                }

            
            MyProfile()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                        
                }
        }.tint(Color.primary)
      
            .environmentObject(favouriteWallpapersModel)
    }
}



