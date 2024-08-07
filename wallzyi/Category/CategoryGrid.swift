
import SwiftUI
import UIKit
struct Category: Identifiable,Hashable {
    let id : UUID
    let name: String
    let displayName: String
    let imageName: String
    
    init(id: UUID,name: String) {
        self.id = id
        self.name = name
        self.displayName = name.capitalized
        self.imageName = name.lowercased()
    }
}

struct Categorygrid: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 0) {
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            
            Text(category.displayName)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.5)
        )
        .padding(5)
    }
}

struct categorygrid : View {
    @State private var selectedCategory : String?
    @State private var shuffledCategories: [Category]
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 200))]
    let categories: [Category] = [
        Category(id: UUID(), name: "Abstract"),
        Category(id: UUID(), name: "Cars"),
//        Category(id: UUID(), name: "Anime"),
        Category(id: UUID(), name: "Cityscapes"),
        Category(id: UUID(), name: "Cyberpunk"),
        Category(id: UUID(), name: "Amoled"),
//        Category(id: UUID(), name: "Super Hero"),
        Category(id: UUID(), name: "Games"),
        Category(id: UUID(), name: "geometry"),
        Category(id: UUID(), name: "Minimal"),
//        Category(id: UUID(), name: "Scenic"),
        Category(id: UUID(), name: "Music"),
//        Category(id: UUID(), name: "Neon"),
        Category(id: UUID(), name: "Quotes"),
        Category(id: UUID(), name: "Space"),
//        Category(id: UUID(), name: "Sports"),
        Category(id: UUID(), name: "Tech"),
        Category(id: UUID(), name: "Vaporwave")
    ]
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        _shuffledCategories = State(initialValue: categories.shuffled())

    }
    var body: some View {
        
        ScrollView {
            ZStack {
                
                LazyVGrid(columns: columns) {
                    ForEach(shuffledCategories) { category in
                        
                        NavigationLink(
                            destination: categoryView(selectedCategory: $selectedCategory,categoryId:category.id))
                        {

                            Categorygrid(category: category)
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded({
                            selectedCategory = category.name
                        }))
                    }
                }
                
            }
            
        }.scrollIndicators(.hidden)
            .background{

                
                Color.primary.ignoresSafeArea()
            }
            .onAppear{
                shuffledCategories = categories.shuffled()
            }
        
        
        
    }
}



#Preview(body: {
    categorygrid()
})
