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

struct CategoryGridView: View {
    
    let category: Category
    //    let categoryId: UUID
    var body: some View {
        VStack {
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
            
            VStack {
                Text(category.displayName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.vertical)
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

struct CategoryGrid: View {
    @State private var selectedCategory : String?
    //    @State private var selectedCategoryId: UUID?
    let columns = [GridItem(.adaptive(minimum: 150))]
    let categories: [Category] = [
        Category(id: UUID(), name: "Abstract"),
        Category(id: UUID(), name: "Cars"),
        Category(id: UUID(), name: "Cartoon"),
        Category(id: UUID(), name: "Cityscapes"),
        Category(id: UUID(), name: "Cyberpunk"),
        Category(id: UUID(), name: "Depth_effect"),
        Category(id: UUID(), name: "Food"),
        Category(id: UUID(), name: "Games"),
        Category(id: UUID(), name: "Geometric"),
        Category(id: UUID(), name: "Kids"),
        Category(id: UUID(), name: "Minimal"),
        Category(id: UUID(), name: "Moon"),
        Category(id: UUID(), name: "Music"),
        Category(id: UUID(), name: "Neon_Lights"),
        Category(id: UUID(), name: "Quotes"),
        Category(id: UUID(), name: "Space"),
        Category(id: UUID(), name: "Sports"),
        Category(id: UUID(), name: "Tech"),
        Category(id: UUID(), name: "Vaporwave"),
        Category(id: UUID(), name: "Live")
    ]
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        
        
    }
    var body: some View {
        
        ScrollView {
            ZStack {
                
                LazyVGrid(columns: columns) {
                    ForEach(categories) { category in
                        
                        NavigationLink(
                            destination: categoryView(selectedCategory: $selectedCategory,categoryId:category.id))
                        {
                            CategoryGridView(category: category)
                        }
                        .simultaneousGesture(TapGesture().onEnded({
                            selectedCategory = category.name
                        }))
                    }
                }
                
            }
            
        }.scrollIndicators(.hidden)
            .background{
                Image("quotes")
                    .resizable()
                    .scaledToFill()
                //  .ignoresSafeArea()
                    .blur(radius: 4)
            }
            .ignoresSafeArea()
        
        
        
    }
}

#Preview{
    CategoryGrid()
}

