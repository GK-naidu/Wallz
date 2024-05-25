//
//
//import SwiftUI
//
//struct Categories : View {
//    @State private var isOn: Bool = false
//    var body: some View {
//        
//        VStack {
//            if isOn {
//                
//                CategoryList()
//                
//            }
//            else {
//                CategoryGrid()
//            }
//        }
//        
//        
//        .navigationTitle("Wallzyfy")
//        .preferredColorScheme(.dark)
//        .toolbar{
//            Toggle(isOn: $isOn) {
//                Image(systemName: "list.bullet")
//            }.toggleStyle(.switch)
//            
//            
//        }
//        
//    }
//    
//}
