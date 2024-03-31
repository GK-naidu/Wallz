import SwiftUI
import Photos


class FavouriteWallpapersModel: ObservableObject {
    @Published var favouriteWallpapers: [String] = []
    
    init() {
        if let savedWallpapers = UserDefaults.standard.array(forKey: "favouriteWallpapers") as? [String] {
            favouriteWallpapers = savedWallpapers
        }
    }
    
    func toggleFavorite(_ url: String) {
        if favouriteWallpapers.contains(url) {
            favouriteWallpapers.removeAll { $0 == url }
        } else {
            favouriteWallpapers.append(url)
        }
        saveWallpapers()
    }
    
    private func saveWallpapers() {
        UserDefaults.standard.set(favouriteWallpapers, forKey: "favouriteWallpapers")
    }
}


struct WallScreen: View {
  
    @State var imageData : ImageData?
    
    @State private var  isFavourite: Bool = false
    
    @State private var downloadAlert = false
    
    @State private var buttonPressed = 0
    
//    @State private var favouriteWallpapers: [String] = []
    @EnvironmentObject var favouriteWallpapersModel: FavouriteWallpapersModel
    
    
     func FavouriteWallpaper( favWall string : String )  {
        
        let userdefaults = UserDefaults.standard
        
        var favwalls : [String] = userdefaults.object(forKey: "favWALL") as? [String] ?? []
       
        if buttonPressed == 1 && isFavourite {
            
            favwalls.append(string)
            userdefaults.set(favwalls,forKey: "favWALL")
   
        }
        else  {
         print("else from favouriteWallpaper loaded")
        }
       
        

    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            
                .ignoresSafeArea()
            VStack{
                AsyncImage(url: URL(string: imageData?.url ?? "" )) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 500)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                    } else {
                        ProgressView()
                            .frame(width: 250, height: 500)
                            .padding()
                    }
                }
                
                HStack {
                    
                    Button(action: {
                        if let url = URL(string: imageData?.url ?? "" ) {
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
                   
                    
                    Button(action: {
                        favouriteWallpapersModel.toggleFavorite(imageData?.url ?? "")
                    }) {
                        Circle()
                            .overlay(content: {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.red)
                                    .frame(width: 30, height: 25)
                            })
                            .frame(width: 50,height: 50)
                            .foregroundStyle(Color.black)
                            .padding()

                        
                    }
                 
                }
            }
            .ignoresSafeArea()
        }
    }
}




