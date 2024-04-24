import SwiftUI
import Photos
import UIKit
import RiveRuntime



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
    
    let columns = [
        GridItem(),
        GridItem()
    ]

    @State var imageData : ImageData?

    @State private var  isFavourite: Bool = false

    @State private var downloadAlert = false

    @State private var buttonPressed = 0

    @State private var extractedColors: [UIColor] = []

    @EnvironmentObject var favouriteWallpapersModel: FavouriteWallpapersModel
    
    @State private var showLockOverlay : Bool = false
    @State private var showHomeOverlay : Bool = false


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
            LinearGradient(gradient: Gradient(colors: [Color("9D92DF"), Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
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

                    //MARK: -  download button
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
                        
                        RoundedRectangle(cornerRadius: 20)
                            .overlay {
                                Image(systemName: "arrowshape.down.fill")
                                    .foregroundStyle(Color.white)
                                    .frame(width: 30,height: 30)
                                    
                            }
                            .foregroundStyle(Color.black)
                            .frame(width: 50,height: 50)
                            .padding()
                         
                    }
                    .padding()

                    //MARK: -  Favourite Button
                    Button(action: {
                        favouriteWallpapersModel.toggleFavorite(imageData?.url ?? "")
                    }) {
                        Circle()
                            .overlay(content: {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color.red)
                                    .frame(width: 30, height: 25)
                            })
                            .frame(width: 50,height: 50)
                            .foregroundStyle(Color.black)
                            .padding()


                    }

                    
                     
                        //MARK: - lockOverlay button
                            RoundedRectangle(cornerRadius: 20)
                                .overlay {
                                    Image(systemName: "lock.fill")
                                        .foregroundStyle(Color.white)
                                        .frame(width: 30,height: 30)
                                        
                                }
                                .foregroundStyle(Color.black)
                                .frame(width: 50,height: 50)
                    
                                .padding()
                                .onTapGesture {
                                    showLockOverlay = true
                                }
                                .fullScreenCover(isPresented: $showLockOverlay, content: {
                                    LockOverlay(imageData: imageData )
                                 
                        })
                        
                   
                        
                        Button {
                            showHomeOverlay = true
                                
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .overlay {
                                    Image(systemName: "house.fill")
                                        .foregroundStyle(Color.white)
                                        .frame(width: 30,height: 30)
                                        
                                }
                                .foregroundStyle(Color.black)
                                .frame(width: 50,height: 50)
                                .padding()
                        }
                        .fullScreenCover(isPresented: $showHomeOverlay, content: {
                            HomeOverlay(imageData: imageData)
                        })
                    

                }
                
            }
            .ignoresSafeArea()
        }   .overlay {
            if downloadAlert == true {
                
                RiveViewModel(fileName: "DownloadAnimation").view()
                    .frame(width: 200,height: 200)
                    .padding()
                    
                
            }
        }
    }
        
}
