import SwiftUI
import Combine

public class CategoryViewModel: ObservableObject {
    @Published var publishedCategory: String?
    
    func updateCategory(_ category: String?) {
        publishedCategory = category
    }
}

struct categoryView: View {
    
    @Binding var selectedCategory: String?
    let categoryId: UUID
    @ObservedObject private var viewModel = CategoryViewModel()
    @State private var backgroundImageName: String = "anime"
    @State private var page: Int = 1
    private var cancellable: AnyCancellable? = nil
    @State private var isLoadingMore: Bool = false
    @State private var hasReachedEnd: Bool = false
    
    let columns = [
        GridItem(),
        GridItem()
    ]
    
    @State private var categoryData: [CategoryData] = []
    @State private var selectedImage: CategoryData?
    @State private var Uniquecategories: String = ""
    
    @State private var showWallscreen: Bool = false
    
    public init(selectedCategory: Binding<String?>, categoryId: UUID) {
        self._selectedCategory = selectedCategory
        self.categoryId = categoryId
    }
    
    @State private var GoToCategoryWall: Bool = false
    
    public var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                AsyncImage(url: URL(string: backgroundImageName)) { phase in
                    
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 7)
                            .ignoresSafeArea()
                            
                    }
                    
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(categoryData) { item in
                            
                            NavigationLink(value: item) {
                                
                                RemoteImage(url: (item.lowQualityUrl) ?? "Nil")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    
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
                        updateBackgroundImage()
                        loadcategoriesData(page: page)
                        
                        print(selectedCategory ?? "Nil value")
                    }
                    .onChange(of: categoryData.count) { oldValue, newValue in
                        if !isLoadingMore && !hasReachedEnd {
                            isLoadingMore = true
                            loadcategoriesData(page: page + 1)
                            page += 1
                            print("\(page)")
                        }
                    }
                    
                }
                
            }
            
        }
        
        .navigationDestination(isPresented: $GoToCategoryWall) {
            CategoryWall(categoryData: selectedImage)
        }
        
    }
    
    func loadcategoriesData(page: Int) {
        guard let category = selectedCategory else { return }
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        let urlString = "https://wallzy.vercel.app/api/?page=\(page)&categories=\(encodedCategory.lowercased())"
        print("URL: \(urlString)")
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    isLoadingMore = false
                    return
                }
                
                guard let data = data else {
                    print("No data returned")
                    isLoadingMore = false
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([CategoryData].self, from: data)
                    DispatchQueue.main.async {
                        self.categoryData.append(contentsOf: decodedData)
                        self.isLoadingMore = false
                        if decodedData.count < 8 {
                            self.hasReachedEnd = true
                        }
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    isLoadingMore = false
                }
            }
            .resume()
        } else {
            print("Invalid URL: \(urlString)")
            return
        }
    }
    

    
    private func updateBackgroundImage() {
            switch selectedCategory?.lowercased() {
            case "abstract":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719487384/co5ldn5p5k8spoez5cxr.jpg"
            case "cars":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719487740/nfb3lsn99a4xogkuxtyk.jpg"
            case "anime":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1711861577/kvssq8oedeiia3iuv3lp.jpg"
            case "cityscapes":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719487840/nawnqkchdjdugp8cecif.jpg"
            case "amoled" :
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1712315438/cw0bjskjzuz1yemvrtrb.jpg"
            case "cyberpunk":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719487869/aw14fq9m2eqkki3n2ghn.jpg"
            case "depth_effect":
                backgroundImageName = "depth_effect"
            case "food":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488002/oa8yfim8eoycftpawmgw.jpg"
            case "games":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488057/c2pylmxpcfwg2jfiljlj.jpg"
            case "geometric":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488097/t2prfbtgqt8anuvpu3bg.jpg"

            case "minimal":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1711794855/mabkvanufweldpmkqiw7.jpg"
            case "moon":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488177/dbzskc5nzxjcw7txgwmd.jpg"
            case "music":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488205/fxg5uiumuietztzrmhvl.jpg"
            case "neon_lights":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488233/jsbk1ibzm3t59yhtb6el.jpg"
            case "quotes":
                backgroundImageName = "quotes"
            case "space":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488274/zwm8zkuqxtbvrh4qa6bl.jpg"
            case "sports":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488297/ey7vgpsuvpav9knsjcfc.jpg"
            case "tech":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488321/cvvirckxfxdeaut8cadh.jpg"
            case "vaporwave":
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1719488373/j9ojduaasphcltvp6rdt.jpg"
            default:
                backgroundImageName = "https://res.cloudinary.com/dq0rchxli/image/upload/v1711796669/zsdgj4m3vyvrvnrcsrza.jpg"
            }
        }
}



