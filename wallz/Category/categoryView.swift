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

struct categoryView: View {
    
    @Binding  var selectedCategory: String?
    let categoryId : UUID
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
    @State private var Uniquecategories : String = ""
    //    @EnvironmentObject private var settings: UserSettings
    @ObservedObject var sharedData = SharedData.shared
    @State private var showWallscreen : Bool = false
    
    public init(selectedCategory: Binding<String?>,categoryId : UUID) {
        self._selectedCategory = selectedCategory
        self.categoryId = categoryId
        
    }
    
    @State private var GoToCategoryWall : Bool = false
    
    public  var body: some View {
        
        NavigationStack {
            
            ZStack {
                // add a background clolour ( or ) image
                
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

                            .simultaneousGesture(TapGesture().onEnded({ desti in
                                selectedImage = item
                                GoToCategoryWall = true
                                showWallscreen = true
                            }))
                            

                            
                        }
                    }
                    .padding()
                    .onAppear {
                        loadcategoriesData(page: page)
                        
                        print(selectedCategory ?? "Nil value")
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
                
            }

        }
        
//        .navigationDestination(for: CategoryData.self) {  category in
//            CategoryWall(categoryData: selectedImage)
//                .environmentObject(likedWallpapersModel)
//        }
        .navigationDestination(isPresented: $GoToCategoryWall) {
            CategoryWall(categoryData: selectedImage)
                .environmentObject(likedWallpapersModel)
        }
        
    }
    
    func loadcategoriesData(page : Int) {
//        guard let category = selectedCategory, let url = URL(string: "https://long-lamb-cuff-links.cyclic.app/api/?categories=\(category.lowercased())&page=\(page)") else { return }
        
        guard let category = selectedCategory, let url = URL(string: "https://wallpaper-api-p0xg.onrender.com/api/?categories=\(category.lowercased())&page=\(page)") else { return}
        
//        guard let category = selectedCategory , let url = URL(string: "https://supabase.com/dashboard/project/bxjztqqobhymgyozypig/storage/buckets/wallzy_walls_test") else { return }
        
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


