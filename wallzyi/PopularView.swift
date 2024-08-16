
import SwiftUI
import GoogleMobileAds

public struct PopularView: View {
    @State private var data: [ImageData] = []
    @State private var selectedImageIndex: Int?
    @State var showSplash: Bool = false
    @State private var page: Int
    private let limit = 10
    private var offset = 0
    @State private var isLoadingMore: Bool = false
    @State private var isLoading = false
    let coloursRandom: [Color] = [.white, .blue, .green, .pink]
    @State private var BGColour: Color = .yellow
//    @State private var interstitialAdsManager = InterstitialAdsManager()
    
    // Binding to control tab bar visibility
    @Binding var isTabBarHidden: Bool

    let columns = [
        GridItem(),
        GridItem()
    ]

    public init(isTabBarHidden: Binding<Bool>) {
        page = Int.random(in: 1...141)
        _isTabBarHidden = isTabBarHidden
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    
                    
                    BannerContentView()
                        .frame(height: 40)
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                                    NavigationLink(value: index) {
                                        RemoteImage(url: item.lowQualityUrl ?? "nil")
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 350)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .shadow(radius: 9)
                                            .padding()
                                    }
                                    .id(item.id)
                                    .onAppear {
                                        if index == data.count - 1 {
                                            loadMoreImages()
                                        }
                                    }
                                }
                            }
                            .padding()
                            .onScrollingChange(
                                onScrollingDown: {
                                    withAnimation(.spring()) {
                                        isTabBarHidden = true
                                    }
                                },
                                onScrollingUp: {
                                    withAnimation(.spring()) {
                                        isTabBarHidden = false
                                    }
                                },
                                onScrollingStopped: {
                                    withAnimation(.spring()) {
                                        isTabBarHidden = false
                                    }
                                }
                            )
                        }
                        .onAppear {
                            if data.isEmpty {
                                isLoading = true
                                loadData(page: page)
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    

                    
                }
                
                if isLoading {
                    Text("Just a moment")
                }
            }
            .toolbar(.hidden)
            .navigationDestination(for: Int.self) { index in
                WallScreen(imageData: data, currentImageIndex: index)
//                    .environmentObject(interstitialAdsManager)
                    .onAppear {
//                        interstitialAdsManager.loadInterstitialAd()
                    }
            }
        }
    }

    func loadMoreImages() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        page = (page % 141) + 1
        loadData(page: page)
    }
    
    public func loadData(page: Int) {
        guard let url = URL(string: "https://wallzyi.vercel.app/api/?page=\(page)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([ImageData].self, from: data)
                    DispatchQueue.main.async {
                        print("Decoded \(decodedData.count) images")
                        var newData: [ImageData] = []
                        for image in decodedData {
                            let newImage = image
                            print("Image ID: \(newImage.id)")
                            print("--------------------")
                            newData.append(newImage)
                        }
                        self.data.append(contentsOf: newData)
                        self.isLoadingMore = false
                        self.isLoading = false
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    isLoadingMore = false
                    isLoading = false
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
                isLoadingMore = false
                isLoading = false
            }
        }.resume()
    }
}

#Preview {
    PopularView(isTabBarHidden: .constant(false))
}
