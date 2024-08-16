import SwiftUI

struct Category: Identifiable, Hashable {
    let id: UUID
    let name: String
    let displayName: String
    let imageName: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
        self.displayName = name.capitalized
        self.imageName = name.lowercased()
    }
}

struct categorygrid: View {
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
                .foregroundColor(.yellow)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.black)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.yellow, lineWidth: 0.5)
        )
        .padding(5)
    }
    
}

struct CategoryGridView: View {
    @State private var selectedCategory : String?
    
    let categories: [Category] = [
        Category(id: UUID(), name: "Abstract"),
        Category(id: UUID(), name: "Cars"),
        Category(id: UUID(), name: "Cityscapes"),
        Category(id: UUID(), name: "Cyberpunk"),
        Category(id: UUID(), name: "Amoled"),
        Category(id: UUID(), name: "Games"),
        Category(id: UUID(), name: "geometry"),
        Category(id: UUID(), name: "Minimal"),
        Category(id: UUID(), name: "Music"),
        Category(id: UUID(), name: "Quotes"),
        Category(id: UUID(), name: "Space"),
        Category(id: UUID(), name: "Tech"),
        Category(id: UUID(), name: "Vaporwave")
    ]
    
    var body: some View {
        NavigationStack {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))]) {
                ForEach(categories) { category in
                    NavigationLink(
                        destination: categoryView(selectedCategory: $selectedCategory,categoryId:category.id))
                    {
                        
                        categorygrid(category: category)
                        
                    }
                    .simultaneousGesture(TapGesture().onEnded({
                        selectedCategory = category.name
                    }))
                    
                }
            }
            .padding()
            .background(Color.black)
            
        }
        
        .scrollIndicators(.never)
        .background(Color.black)
        
    }
    }
}

struct CategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryGridView()
    }
}
