import SwiftUI
import Photos
import UIKit

struct CategoryWall: View {
    let columns = [
        GridItem(),
        GridItem()
    ]
    
    @State var categoryData: CategoryData?
    @State private var isFavourite: Bool = false
    @State private var downloadAlert = false
    @State private var buttonPressed = 0
    @State private var extractedColors: [UIColor] = []
    @State private var showLockOverlay: Bool = false
    @State private var showHomeOverlay: Bool = false
    @State private var goback: Bool = false
    
//    @EnvironmentObject var LikedWallpapersModel: LikedWallpapersModel
    
    func FavouriteWallpaper(favWall string: String) {
        let userdefaults = UserDefaults.standard
        var favwalls: [String] = userdefaults.object(forKey: "favWALL") as? [String] ?? []
        
        if buttonPressed == 1 && isFavourite {
            favwalls.append(string)
            userdefaults.set(favwalls, forKey: "favWALL")
        } else {
            print("else from favouriteWallpaper loaded")
        }
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                AsyncImage(url: URL(string: categoryData?.highurl ?? "")) { phase in
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
                    // Download button
                    Button(action: {
                        guard let urlString = categoryData?.lowurl,
                              let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                              let url = URL(string: encodedURLString) else {
                            print("Invalid URL: \(categoryData?.highurl ?? "Nil URL")")
                            return
                        }
                        
                        print("Attempting to download from URL: \(url.absoluteString)")
                        
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error {
                                print("Error downloading image: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let data = data, let image = UIImage(data: data) else {
                                print("Error processing image data")
                                return
                            }
                            
                            PHPhotoLibrary.requestAuthorization { status in
                                if status == .authorized {
                                    PHPhotoLibrary.shared().performChanges({
                                        let creationRequest = PHAssetCreationRequest.forAsset()
                                        if let jpegData = image.jpegData(compressionQuality: 1.0) {
                                            creationRequest.addResource(with: .photo, data: jpegData, options: nil)
                                        }
                                    }, completionHandler: { success, error in
                                        DispatchQueue.main.async {
                                            if success {
                                                downloadAlert = true
                                            } else if let error = error {
                                                print("Error saving image: \(error.localizedDescription)")
                                            }
                                        }
                                    })
                                } else {
                                    print("Photo library access denied")
                                }
                            }
                        }.resume()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .overlay {
                                Image(systemName: "arrowshape.down.fill")
                                    .foregroundStyle(Color.white)
                                    .frame(width: 30, height: 30)
                            }
                            .foregroundStyle(Color.black)
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    .alert("Saved to Photos", isPresented: $downloadAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .padding()

                    // Favorite button (commented out in your original code)
                    /*
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
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.black)
                            .padding()
                    }
                    */
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            print(categoryData ?? "Nil category")
        }
    }
}
