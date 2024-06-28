
import SwiftUI

struct MyProfile: View {
    @State private var changeBackground : Bool = false
    @State private var showFeatureRequestView : Bool = false
    @State private var userName : String = "NIL"
    
    private let cache = NSCache<NSString, UIImage>()
    
    @State private var cacheAlert = false
    
//    @StateObject private var settings = UserSettings(initialColor: .white)
    var body: some View {

            Form{
          
                    
           
                    
//                Section {
//                    Text("Change app background colour")
//                        .onTapGesture {
//                            changeBackground = true
//                        }
//
//                        .fullScreenCover(isPresented: $changeBackground, content: {
//                            BackgroundColour()
//                                
//                        })
//                            
//                        
//                
//                }
                    
                Section {
                    Text("Rate our app ⭐️⭐️⭐️⭐️⭐️")
                    
                    
                }
                
                
                Section {
                    Text("Feedback or suggestions")
                        .onTapGesture {
                            showFeatureRequestView = true
                        }
                       
                        .sheet(isPresented: $showFeatureRequestView, content: {
                            FeatureRequestView()
                        })
                } header: {
                     Text("Contact Us")
                }
                    
                Section {
                    Button("Clear Cache") {
                        cache.removeAllObjects()
                        cacheAlert = true
                        
                        
                    }
                    .alert("Cache cleared", isPresented: $cacheAlert) {
                        
                    }
                } header: {
                    Text("clear in app cache")
                }
                
                
                Section {
                    
                    Link("Privacy policy", destination: URL(string: "https://long-lamb-cuff-links.cyclic.app/policy")!)
                    
                }header: {
                    Text("App privacy policy")
                }
                
            }
        
            
            
            
            
        }
    
    
}

#Preview {
    MyProfile()
}
