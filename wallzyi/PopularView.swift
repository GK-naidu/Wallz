import SwiftUI

public struct PopularView: View {
    @State private var data: [ImageData] = []
    @State private var selectedImageIndex: Int?
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
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                                NavigationLink(value: index) {
                                    RemoteImage(url: item.lowQualityUrl ?? "nil")
                                       .aspectRatio(contentMode:.fill)
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
                    }
                   .onAppear {
                        if data.isEmpty {
                            loadData(page: page)
                        }
                    }
                }
            }
           .toolbar(.hidden)
           .navigationDestination(for: Int.self) { index in
                WallScreen(imageData: data, currentImageIndex: index)
            }
        }
    }

    func loadMoreImages() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        page += 1
        loadData(page: page)
    }
    
    public func loadData(page: Int) {
        guard let url = URL(string: "https://wallzy.vercel.app/api/?page=\(page)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([ImageData].self, from: data)
                    DispatchQueue.main.async {
                        print("Decoded \(decodedData.count) images")
                        var newData: [ImageData] = []
                        for image in decodedData {
                            var newImage = image
                            print("Image ID: \(newImage.id)")
                            print("Image Name: \(newImage.name)")
                            print("--------------------")
                            
                            newData.append(newImage)
                        }
                        self.data.append(contentsOf: newData)
                        self.isLoadingMore = false
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case.keyNotFound(let key, let context):
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case.valueNotFound(let value, let context):
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case.typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case.dataCorrupted(let context):
                            print("Data corrupted:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
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
