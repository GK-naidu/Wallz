
import SwiftUI

struct FavouriteView: View {
    @EnvironmentObject var favouriteWallpapersModel: FavouriteWallpapersModel

    var body: some View {
        if !favouriteWallpapersModel.favouriteWallpapers.isEmpty {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                
                    ForEach(favouriteWallpapersModel.favouriteWallpapers, id: \.self) { favourite in
                        AsyncImage(url: URL(string: favourite)) { phase in
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
                        .padding()
                    }
                }
            }
            .padding()
        }
        else {
            VStack {
                Text("You did not like any wallpapers yet ?? ☹️")
                    .font(.largeTitle)
                    .padding()
                Text("Go and like ❤️ some of them !!")
                    .font(.title)
                
            }
        }
    }
}


