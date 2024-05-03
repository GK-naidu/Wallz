
import SwiftUI

import SwiftUI

struct profileModifer : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundStyle(Color.primary)
            .frame(maxWidth: 350,maxHeight: 70)
            .background(RoundedRectangle(cornerRadius: 20))
            
            .padding()
    }
    
    
}

struct MyProfile: View {
    @State private var changeBackground : Bool = false
    @State private var showFeatureRequestView : Bool = false
    @State private var userName : String = "NIL"
    @ObservedObject var sharedData = SharedData.shared
    
//    @StateObject private var settings = UserSettings(initialColor: .white)
    var body: some View {
        

        
      
            List{
                Section {
                    
                    Link("Privacy policy", destination: URL(string: "https://long-lamb-cuff-links.cyclic.app/policy")!)
                    
                }.padding()
                    .listRowBackground(Capsule().fill(Color.black).opacity(0.5))
                Section {
                    Text("Rate our app ⭐️⭐️⭐️⭐️⭐️")
                }.padding()
                    .listRowBackground(Capsule().fill(Color.black).opacity(0.5))
                Section {
                    Text("Change app background colour")
                        .onTapGesture {
                            changeBackground = true
                        }

                        .fullScreenCover(isPresented: $changeBackground, content: {
                            BackgroundColour()
                                .environmentObject(sharedData)
                        })
                            
                        
                
                }.padding()
                    .listRowBackground(Capsule().fill(Color.black).opacity(0.5))
                Section {
                    Text("Feature Requeset")
                        .onTapGesture {
                            showFeatureRequestView = true
                        }
                       
                        .sheet(isPresented: $showFeatureRequestView, content: {
                            FeatureRequestView()
                        })
                }.padding()
                    .listRowBackground(Capsule().fill(Color.black).opacity(0.5))
            }
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
            .foregroundStyle(Color.white)
            .background{
//                settings.backgroundColor.ignoresSafeArea()
                sharedData.backgroundColor.ignoresSafeArea()
                
            }
            
        }
    
    
}

#Preview {
    MyProfile()
}
