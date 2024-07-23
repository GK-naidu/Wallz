import SwiftUI
import Photos
import UIKit

struct WallScreen: View {
    let columns = [GridItem(), GridItem()]
    @State var imageData: [ImageData]
    @State var currentImageIndex: Int
    @State private var isFavourite: Bool = false
    @State private var downloadAlert = false
    @State private var buttonPressed = 0
    @State private var extractedColors: [UIColor] = []
    @State private var showLockOverlay: Bool = false
    @State private var showHomeOverlay: Bool = false
    @State private var isFullscreen: Bool = false

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: imageData[currentImageIndex].lowQualityUrl ?? "nil Url"))
                .blur(radius: 9)
                .ignoresSafeArea()
            
            VStack {
                AsyncImage(url: URL(string: imageData[currentImageIndex].lowQualityUrl ?? " Nil url")) { phase in
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
                        Button(action: downloadImage) {
                            RoundedRectangle(cornerRadius: 20)
                                .overlay {
                                    Image(systemName: "arrowshape.down.fill")
                                        .foregroundStyle(Color.white)
                                        .frame(width: 30, height: 30)
                                }
                                .foregroundStyle(Color.black)
                                .frame(width: 50, height: 50)
                        }
                        
                        // Fullscreen button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isFullscreen = true
                            }
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
                }
            }
            .ignoresSafeArea()

            if isFullscreen {
                FullscreenImageView(
                    imageURLs: imageData.compactMap { URL(string: $0.lowQualityUrl ?? "") },
                    currentIndex: $currentImageIndex,
                    isFullscreen: $isFullscreen
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .alert("Saved to Photos", isPresented: $downloadAlert) {
            Button("OK") {}
        }
        .onAppear {
            print("Original URL: \(String(describing: imageData[currentImageIndex].url))")
        }
    }
         
    private func downloadImage() {
        let originalURL = imageData[currentImageIndex].highQualityUrl
        
        if let url = URL(string: originalURL ?? "N I L") {
            print("Downloading from URL: \(String(describing: originalURL))")
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    PHPhotoLibrary.requestAuthorization { status in
                        if status == .authorized {
                            PHPhotoLibrary.shared().performChanges({
                                let creationRequest = PHAssetCreationRequest.forAsset()
                                creationRequest.addResource(with:.photo, data: data, options: nil)
                            }, completionHandler: { success, error in
                                DispatchQueue.main.async {
                                    if success {
                                        downloadAlert = true
                                        print("Image successfully saved to Photos")
                                    } else if let error = error {
                                        print("Error saving image: \(error.localizedDescription)")
                                        downloadAlert = false
                                    }
                                }
                            })
                        } else {
                            print("Photo library access denied")
                        }
                    }
                } else if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }.resume()
        } else {
            print("Invalid URL: \(String(describing: originalURL))")
        }
    }
}
