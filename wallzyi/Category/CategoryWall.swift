import SwiftUI
import Photos
import UIKit

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
    
    var highQualityURL: URL? {
        guard let urlString = categoryData?.highQualityUrl,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: categoryData?.lowQualityUrl ?? "Nil"))
                .blur(radius: 9)
                .ignoresSafeArea()
            VStack {
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
                        .frame(width: 250,height: 75)
                        .foregroundStyle(Color.white)
                    HStack {
                        // Download button
                        Button(action: {
                            if let categoryData = categoryData {
                                guard let urlString = categoryData.highQualityUrl,
                                      let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                      let url = URL(string: encodedURLString) else {
                                    print("Invalid URL: \(String(describing: categoryData.url))")
                                    return
                                }
                                
                                print("Attempting to download from URL: \(url.absoluteString)")
                                
                                URLSession.shared.dataTask(with: url) { data, response, error in
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
                            } else {
                                print("categoryData is nil")
                            }
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
                                .padding()
                        }
                    }
                    .padding()
                    .ignoresSafeArea()
                }
            }
            if isFullscreen {
                FullscreenImageView(
                    imageURLs: [highQualityURL].compactMap { $0 },
                    currentIndex: $currentImageIndex,
                    isFullscreen: $isFullscreen
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .onAppear {
            print(categoryData ?? "Nil category")
        }
    }
}
