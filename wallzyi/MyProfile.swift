import SwiftUI

struct MyProfile: View {
    @State private var changeBackground: Bool = false
    @State private var showFeatureRequestView: Bool = false
    @State private var userName: String = "NIL"
    
    private let cache = NSCache<NSString, UIImage>()
    
    @State private var cacheCleared = false
    
    var body: some View {
        Form {

            
            Section(header: Text("Rating")) {
                Link("Rate the app", destination: URL(string: "https://apps.apple.com/in/app/wallzyi/id6523413546?action=write-review")!)
            }
            
            Section(header: Text("Contact Us")) {
                Text("Feedback or suggestions")
                    .onTapGesture {
                        showFeatureRequestView = true
                    }
                    .sheet(isPresented: $showFeatureRequestView, content: {
                        FeatureRequestView()
                    })
            }
            
            Section(header: Text("Cache")) {
                Button(action: {
                    cache.removeAllObjects()
                    cacheCleared = true
                }) {
                    Text("Clear Cache")
                }
                .alert("Cache cleared", isPresented: $cacheCleared) {
                    Button("OK") {}
                }
            }
            
            Section(header: Text("App Info")) {
                Link("Privacy policy", destination: URL(string: "https://wallzyi.vercel.app/policy")!)
                Text("Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)")
                    .opacity(0.5)
                    .font(.subheadline)
            }
          
        
     
            
        }
        .preferredColorScheme(.dark)
   
        
       
    }
}

#Preview {
    MyProfile()
}
