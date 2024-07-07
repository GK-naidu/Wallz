
import SwiftUI

public struct PopularView: View {
    @State private var data: [ImageData] = []
    @State private var selectedImage: ImageData?
    @StateObject private var favouriteWallpapersModel = FavouriteWallpapersModel()
    @State var showSplash: Bool = false
    @State private var page: Int = 1
    private let limit = 10
    private var offset = 0
    @State private var isLoadingMore: Bool = false
    let coloursRandom : [Color] = [.white,.blue,.green,.pink]
    @State private var BGColour : Color = .yellow
    
    let columns = [
        GridItem(),
        GridItem()
    ]

    public var body: some View {
        GeometryReader {geometry in 
            ZStack {
                
//                Image("AppBackground")
//                    .resizable()
//                    .scaledToFill()
//                    .blur(radius: 8)
//                    .ignoresSafeArea()
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data) { item in
                            NavigationLink(value: item) {
                                RemoteImage(url: item.url)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                                    .shadow(radius: 9)
                                    .padding()
                            }
                            .task {
                                if item == data.last {
                                    loadMoreImages()
                                    print("Last element")
                                }
                            }
                            .onTapGesture {
                                selectedImage = item
                            }
                        }
                        
                    }
                    .padding()
                    .onAppear {
                        loadData(page: page)
                        print(data.count)
                    }
                    
                }
                
            }
            .toolbar(.hidden)
            .navigationDestination(for: ImageData.self) { image in
                WallScreen(imageData: image)
                    .environmentObject(favouriteWallpapersModel)
            }
            
        }
    }

    func loadMoreImages() {
        page += 1
        loadData(page: page)
    }
    
  public  func loadData(page: Int) {
        guard let url = URL(string: "https://wallzy.vercel.app/api/?page=\(page)") else { return }
      
//      guard let url = URL(string: "https://wallzy.vercel.app/api/?name=fiber") else { return }

      
      URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([ImageData].self, from: data)
                    DispatchQueue.main.async {
                        self.data.append(contentsOf: decodedData)
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

class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    

    private init() {}

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}


struct RemoteImage: View {
    
    @ObservedObject var imageLoader: ImageLoader

    init(url: String) {
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
            
        } else {
            ProgressView()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var url: String
    private var task: URLSessionDataTask?

    init(url: String) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: url) else { return }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
                ImageCache.shared.set(image!, forKey: self.url)
                
            }
        }
        task?.resume()
    }
}
