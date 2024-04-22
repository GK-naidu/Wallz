
import SwiftUI

public struct HomeView: View {
    @State private var data: [ImageData] = []
    @State private var selectedImage: ImageData?
    @State var showSplash: Bool = false
    @State private var page: Int = 1
    @State private var isLoadingMore: Bool = false

    let columns = [
        GridItem(),
        GridItem()
    ]

    public var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("9D92DF"), Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data) { item in
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
                            }
                        }
                       
                    }
                    .padding()
                    .onAppear {
                        loadData(page: page)
                        print(data.count)
                    }
                    

                    .onChange(of: data.count) { oldValue, newValue in
                        if !isLoadingMore && data.count > 0 {
                            isLoadingMore = true
                            loadData(page: page + 1)
                            page += 1
                        }
                    }
                }
            }
            .toolbar(.hidden)
            .navigationDestination(for: ImageData.self) { image in
                WallScreen(imageData: image)
            }
        }
       
    }

  public  func loadData(page: Int) {
        guard let url = URL(string: "https://long-lamb-cuff-links.cyclic.app/api?page=\(page)") else { return }
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
