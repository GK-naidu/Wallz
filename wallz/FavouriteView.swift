
import SwiftUI
import Photos

struct FavouriteView: View {
    @EnvironmentObject var favouriteWallpapersModel: FavouriteWallpapersModel
    @State private var downloadAlert = false
    @State var imageData : ImageData?
    
    @State var showPopover = false
    
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
                                    .contextMenu{
                                        Button("UnLike") {
                                            
                                            print("Unliked")
                                            favouriteWallpapersModel.favouriteWallpapers.removeAll{$0 == favourite}
                                            
                                        }
                                        Button(action: {
                                            if let url = URL(string: favourite ) {
                                                URLSession.shared.dataTask(with: url) { data, response, error in
                                                    if let data = data, let image = UIImage(data: data) {
                                                        PHPhotoLibrary.requestAuthorization { status in
                                                            if status == .authorized {
                                                                PHPhotoLibrary.shared().performChanges({
                                                                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                                                                }, completionHandler: { success, error in
                                                                    if success {
                                                                        downloadAlert = true
                                                                    } else if error != nil {
                                                                        downloadAlert = false
                                                                    }
                                                                })
                                                            } else {
                                                                print("Photo library access denied")
                                                            }
                                                        }
                                                    } else {
                                                        print("Error downloading image")
                                                        
                                                    }
                                                }
                                                .resume()
                                            }
                                        }) {
                                            Text("Download")
                                                .font(.system(size: 16))
                                                .foregroundStyle(.white)
                                                .padding()
                                                .frame(maxWidth: 150)
                                                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.black))
                                        }
                                        .alert("Download Successful", isPresented: $downloadAlert) {
                                            Button("OK", role: .cancel) { }
                                        }
                                        .padding()
                                    }
                            }
                            
                            
                            
                            else {
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


