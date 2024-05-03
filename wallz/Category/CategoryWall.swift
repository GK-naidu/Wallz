
import SwiftUI
import Photos
import UIKit



class LikedWallpapersModel: ObservableObject {
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


struct CategoryWall: View {
    
    let columns = [
        GridItem(),
        GridItem()
    ]
    
    @State var categoryData : CategoryData?
    
    @State private var  isFavourite: Bool = false
    
    @State private var downloadAlert = false
    
    @State private var buttonPressed = 0
    
    @State private var extractedColors: [UIColor] = []
    
    @State private var showLockOverlay : Bool = false
    @State private var showHomeOverlay : Bool = false
    
    @EnvironmentObject var LikedWallpapersModel: LikedWallpapersModel
//    @EnvironmentObject private var settings: UserSettings
    @ObservedObject var sharedData = SharedData.shared
    
    
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
            sharedData.backgroundColor.ignoresSafeArea()
            VStack{
                AsyncImage(url: URL(string: categoryData?.url ?? "" )) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 500)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .onAppear{
                                
                            }
                    } else {
                        ProgressView()
                            .frame(width: 250, height: 500)
                            .padding()
                    }
                }
                
                HStack {
                    
                    //MARK: -  download button
                    Button(action: {
                        if let url = URL(string: categoryData?.url ?? "" ) {
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
                    
                    .alert("Download Successful", isPresented: $downloadAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .padding()
                    
                    //MARK: -  Favourite Button
                    Button(action: {
                        LikedWallpapersModel.toggleFavorite(categoryData?.url ?? "")
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
                    
                    
                    
                    
                    //MARK: - lockoverlay
                    
                    
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
                            
                            CategoryLockOverlay(categorydata: categoryData)
                         
                })
                    
                    //MARK: -  homeOverlay button
                    
                    
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
                        
                        CategoryHomeOverlay(categorydata: categoryData)
                    })
                    
                }
                .ignoresSafeArea()
            }
        }
    }
}
