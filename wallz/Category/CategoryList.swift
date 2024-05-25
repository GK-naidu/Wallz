

import SwiftUI

struct CategoryList: View {
    let categorygrid = CategoryGrid()
    //    let category = Category(name: "anime")
    var body: some View {
        
        
        List {
            Section {
                ForEach(categorygrid.categories) { categorylist in
                    NavigationLink {
                        Text("Navigation Link works")
                    } label: {
                        HStack {
                            
                            VStack {
                                Image(categorylist.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 70,height: 70)
                                    .padding()
                                
                                
                            }
                            
                            VStack{
                                
                                Text(categorylist.displayName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.leading,50)
                                
                                
                            }
                            
                            
                        } .frame(width: 300,height: 75)
                        
                        
                        
                    }
                    
                    
                }
                .listRowBackground(Capsule()
                    .fill(
                        .ultraThinMaterial))
                
            }
            
            
            
        } .listRowSpacing(10)
            .scrollContentBackground(.hidden)
            .background{
                Image("quotes")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 4)
                    .ignoresSafeArea()
            }
        
        
    }
}

#Preview {
    CategoryList()
}
