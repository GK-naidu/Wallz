import SwiftUI

//struct FavouriteView: View {
//
////    var wallref = WallScreen()
////    @Binding  var FavouriteWallz : [String]
//    @Binding var favouriteWallpapers: [String]
//    
//    let columns = [
//        GridItem(),
//        GridItem()
//    ]
//    
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: columns, spacing: 10) {
//                
//
//                    ForEach(favouriteWallpapers ,id: \.self) { favourite in
//                            AsyncImage(url: URL(string: favourite)) { phase in
//                                if let image = phase.image {
//                                    
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 150, height: 350)
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    
//                                } else {
//                                    ProgressView()
//                                        .frame(width: 150, height: 350)
//                                        .background(Color.gray)
//                                        .cornerRadius(20)
//                                    
////                                    Text("\(wallref.FWALLS.count)")
//                                    
//                                }
//                            }
//                            .padding()
//                        }
//
//            }
//            
//            .padding()
//        }
//        .onAppear{
//            print("FavouriteView \(favouriteWallpapers.count)")
//        }
//    }
//}

struct FavouriteView: View {
    @EnvironmentObject var favouriteWallpapersModel: FavouriteWallpapersModel
    
    var body: some View {
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
            .padding()
        }
    }
}
