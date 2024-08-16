import SwiftUI
import Photos
import UIKit
import AVFoundation


struct CategoryWall: View {
    let columns = [GridItem(), GridItem()]
    
    @State var categoryData: CategoryData?
    @State private var isFavourite: Bool = false
    @State var imageData: [ImageData]
    @State private var downloadAlert = false
    @State private var buttonPressed = 0
    @State private var extractedColors: [UIColor] = []
    @State private var showLockOverlay: Bool = false
    @State private var showHomeOverlay: Bool = false
    @State private var goback: Bool = false
    @State private var isFullscreen: Bool = false
    @State private var currentImageIndex: Int = 0
//    @EnvironmentObject var interstitialAdsManager: InterstitialAdsManager
    
    var allImageURLs: [URL] {
        return [categoryData].compactMap { $0 }.compactMap { URL(string: $0.lowQualityUrl ?? "") }
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: categoryData?.lowQualityUrl ?? ""))
                .blur(radius: 9)
                .ignoresSafeArea()
            VStack {
                HStack {
                    AsyncImage(url: URL(string: categoryData?.lowQualityUrl ?? "")) { phase in
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            
                            .foregroundStyle(Color.white)
                        VStack {
                            // Download button
                            Button(action: {
                                downloadImage()
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .overlay {
                                        Image(systemName: "arrowshape.down.fill")
                                            .foregroundStyle(Color.white)
                                            .frame(width: 30, height: 30)
                                    }
                                    .foregroundStyle(Color.black)
                                    .frame(width: 50, height: 50)
                                    
                            }
                            .alert("Saved to Photos", isPresented: $downloadAlert) {
                                Button("OK", role: .cancel) { }
                            }
                            
                            // Fullscreen button
                            Button(action: {
                                isFullscreen = true
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .overlay {
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .foregroundStyle(Color.white)
                                            .frame(width: 30, height: 30)
                                    }
                                    .foregroundStyle(Color.black)
                                    .frame(width: 50, height: 50)
                                    
                            }
                        }
                        .padding()
                        
                        
                    }.frame(width: 50,height: 150)
                }
                
                
                BannerContentView()
                    .frame(height: 50)
            }
            if isFullscreen {
                FullscreenImageView(
                    imageURLs: allImageURLs,
                    currentIndex: $currentImageIndex,
                    isFullscreen: $isFullscreen
                )
                .transition(.scale(scale: 1))
                .zIndex(1)
            }
        }
        .onAppear {
            print(categoryData ?? "Nil category")
            print("Decoded \(imageData.count) images")
        }
    }
    
    private func downloadImage() {
        guard let categoryData = categoryData,
              let urlString = categoryData.highQualityUrl,
              let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Invalid URL")
            return
        }
        
        print("Attempting to download from URL: \(url.absoluteString)")
        

            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Error processing image data")
                    return
                }
                
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        PHPhotoLibrary.shared().performChanges({
                            let creationRequest = PHAssetCreationRequest.forAsset()
                            creationRequest.addResource(with: .photo, data: data, options: nil)
                        }, completionHandler: { success, error in
                            DispatchQueue.main.async {
                                if success {
                                    self.downloadAlert = true
                                    print("Image successfully saved to Photos")
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
        
    }
}

#Preview {
    CategoryWall(
        categoryData: CategoryData(
            id: "669bc489286a8e2ed4518e50", highQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484420/mtv8gaafe8194vli019g.png", lowQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484423/zkyrtaofkrtbfjzmxpsz.png"
        ),
        imageData: [
            ImageData(id: "669bc489286a8e2ed4518e50", highQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484420/mtv8gaafe8194vli019g.png", lowQualityUrl: "https://res.cloudinary.com/dq0rchxli/image/upload/v1721484423/zkyrtaofkrtbfjzmxpsz.png")
        ]
     
        
    )
}


