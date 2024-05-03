//
//  Home.swift
//  wallz
//
//  Created by G.K.Naidu on 24/04/24.
//

import SwiftUI

struct Home: View {
    
    @StateObject private var favouriteWallpapersModel = FavouriteWallpapersModel()
    @State var selectedTab : String = "square.stack.3d.up"
    init(){
        UITabBar.appearance().isHidden = true
    }
    var tabs = [""]
    var body: some View {
        
        ZStack(alignment: .bottom, content: {
           
            Section{
                Form{
                    Text("Hello")
                    Text("Two")
                    Text("THree")
                }
            }
            Color("TabBG")
                .ignoresSafeArea()
            //MARK: -  Custom tab Bar
        
            
            CustomTabBar(selectedTab: $selectedTab)
        })
    }
}

#Preview {
    Home()
}
