
import SwiftUI



struct ContentView: View {
    
    
    @StateObject private var favouriteWallpapersModel = FavouriteWallpapersModel()
    
    
    
    var body: some View {
        NavigationStack {
            
            TabView {
                
                categorygrid()
                
                    .tabItem {
                        Label("Categories", systemImage: "square.stack.3d.up.fill")
                    }
                
                
                //                HomeView()
                PopularView()
                    .environmentObject(favouriteWallpapersModel)
                
                    .tabItem {
                        Label("Popular", systemImage: "flame.circle.fill")
                    }
                
                //                FavouriteView()
                //                    .environmentObject(favouriteWallpapersModel)
                //
                //                    .tabItem {
                //                        Label("Liked",systemImage: "hand.thumbsup.fill")
                //                    }
                
                
                MyProfile()
                
                    .tabItem {
                        Label("settings", systemImage: "gearshape.fill")
                        
                    }
            }.tint(Color.primary)
            
                .environmentObject(favouriteWallpapersModel)
            
        }
        
        
    }
}




