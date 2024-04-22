//
//  categoryView.swift
//  wallz
//
//  Created by G.K.Naidu on 02/04/24.
//

import SwiftUI
import Combine


public class CategoryViewModel: ObservableObject {
    @Published var publishedCategory: String?
    
    func updateCategory(_ category: String?) {
        publishedCategory = category
    }
}

 public struct categoryView: View {
    
     @Binding  var selectedCategory: String?
    @ObservedObject private var viewModel = CategoryViewModel()
     
     @State private var page: Int = 1
    private var cancellable: AnyCancellable? = nil
     @State private var isLoadingMore: Bool = false
     
     let likedWallpapersModel = LikedWallpapersModel()
     
    let columns = [
        GridItem(),
        GridItem()
    ]
     
    @State private var categoryData: [CategoryData] = []
    @State private var selectedImage: CategoryData?

    @State private var showWallscreen : Bool = false
     
     public init(selectedCategory: Binding<String?>) {
           self._selectedCategory = selectedCategory
       }
    
    
     public  var body: some View {
         NavigationStack {
             ZStack {
                 LinearGradient(gradient: Gradient(colors: [Color("9D92DF"), Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                     .ignoresSafeArea()
                 ScrollView {
                     LazyVGrid(columns: columns, spacing: 10) {
                         ForEach(categoryData) { item in
                             NavigationLink(value: item) {
                                 
                                 AsyncImage(url: URL(string: item.url)!) { phase in
                                     
                                     if let image = phase.image {
                                         image
                                             .resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(width: 150, height: 350)
                                             .clipShape(RoundedRectangle(cornerRadius: 20))
                                         
                                         
                                     } else {
                                         ProgressView()
                                             .frame(width: 150, height: 350)
                                             .background(Color.gray)
                                             .cornerRadius(20)
                                     }
                                 }
                                 .shadow(radius: 9)
                                 .padding()
                                 
                             }
                             .onTapGesture {
                                 selectedImage = item
                                 showWallscreen = true
                             }
                 
                             
                         }
                     }
                     .padding()
                     .onAppear {
                         loadcategoriesData(page: page)
                 
                     }
                     .onChange(of: categoryData.count) { oldValue, newValue in
                         if !isLoadingMore && categoryData.count > 0 {
                             isLoadingMore = true
                             loadcategoriesData(page: page + 1)
                             page += 1
                             print("\(page)")
                         }
                     }
         
                 }
                 .navigationDestination(for: CategoryData.self) { category in
                     CategoryWall(categoryData: category)
                         .environmentObject(likedWallpapersModel)
                 }
             }
         }
    }
    
     func loadcategoriesData(page : Int) {
        guard let category = selectedCategory, let url = URL(string: "https://long-lamb-cuff-links.cyclic.app/api/?categories=\(category.lowercased())&page=\(page)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([CategoryData].self, from: data)
                    DispatchQueue.main.async {
                        self.categoryData.append(contentsOf: decodedData)
//                        self.categoryData = decodedData
                        self.isLoadingMore = false
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    isLoadingMore = false
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
                isLoadingMore = false
            }
            
        }
        .resume()
        
    }
       
       
}

//#Preview {
//    categoryView()
//}

