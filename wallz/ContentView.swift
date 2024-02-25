
import SwiftUI

struct ContentView: View {
    @State private var favorites: [Favourite] = []

    var body: some View {
        TabView {
            HomeView (favorites: $favorites)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavouriteView(favourites: $favorites)
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


