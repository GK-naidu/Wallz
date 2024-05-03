
import SwiftUI



struct ContentView: View {
    
    
    @StateObject private var favouriteWallpapersModel = FavouriteWallpapersModel()
//    @StateObject private var settings = UserSettings(initialColor: .purple)
    @ObservedObject var sharedData = SharedData.shared
    
    var body: some View {
        
        TabView {
     
                        Categories()
                .environmentObject(sharedData)
                .tabItem {
                    Label("Categories", systemImage: "square.stack.3d.up.fill")
                    
                }
            
            HomeView ()
                .environmentObject(sharedData)
                .tabItem {
                    Label("Popular", systemImage: "flame.circle.fill")
                    
                       
                }
            
            FavouriteView()
                .environmentObject(favouriteWallpapersModel)
                .environmentObject(sharedData)
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



