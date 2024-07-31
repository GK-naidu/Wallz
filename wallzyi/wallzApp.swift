

import SwiftUI
import GoogleMobileAds
@main
struct wallzApp: App {
    
    
    init() {
           GADMobileAds.sharedInstance().start(completionHandler: nil)
       }
    
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                ContentView()
                TabBarTest()
                    .environmentObject(InterstitialAdsManager())
            }
        }
    }
}
