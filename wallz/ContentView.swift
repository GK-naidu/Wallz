import SwiftUI

struct ContentView: View {
    @State private var data: [ImageData] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(data) { item in
                    AsyncImage(url: URL(string: item.url)!) { phase in
                        if let image = phase.image {
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 350)
                                .cornerRadius(20)
                            
                        } else {
                            ProgressView()
                                .frame(width: 150, height: 350)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                loadData()
            }
        }
    }
    
    private func loadData() {
        guard let url = URL(string: "https://wallpaper-api-p0xg.onrender.com/api") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([ImageData].self, from: data)
                    DispatchQueue.main.async {
                        self.data = decodedData
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }
        .resume()
    }
}




