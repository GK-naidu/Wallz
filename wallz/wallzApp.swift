//
//  wallzApp.swift
//  wallz
//
//  Created by G.K.Naidu on 11/02/24.
//

import SwiftUI

@main
struct wallzApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedTab : String = "Categories"
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        .onChange(of: scenePhase,initial: true) { phase,intial  in
            if phase == .active {

                print("app just Launched")
            }
            else if phase == .background {
                print("app just went into Background")
            }
            else if phase == .inactive {
                print("app is InActive")
                HomeView().loadData(page: 1)
            }
            else {
                print("app is kboom ka")
            }
            
                
        }
    }
}
