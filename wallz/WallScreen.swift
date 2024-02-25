//
//  WallScreen.swift
//  wallz
//
//  Created by G.K.Naidu on 25/02/24.
//

import SwiftUI
import Photos




struct WallScreen: View {
    let imageData : ImageData?
    let favourite: Favourite
    @State private var isFavourite: Bool = false
    @State private var favourites: [Favourite] = []


    
//    
//    public init(imageData: ImageData?, favorite: Favourite, isFavorite: Bool) {
//            self.imageData = imageData
//            self.favourite = favorite
//            self._isFavourite = State(initialValue: isFavourite)
//            
//        }
    private func toggleFavorite() {
        if isFavourite {
            if let index = favourites.firstIndex(where: { $0.id == favourite.id }) {
                favourites.remove(at: index)
            }
        } else {
            favourites.append(favourite)
        }
        isFavourite.toggle()
    }
    
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: imageData?.url ?? "")) { phase in
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
                    if let url = URL(string: imageData?.url ?? "") {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                PHPhotoLibrary.requestAuthorization { status in
                                    if status == .authorized {
                                        PHPhotoLibrary.shared().performChanges({
                                            PHAssetChangeRequest.creationRequestForAsset(from: image)
                                        }, completionHandler: { success, error in
                                            if success {
                                                print("Image saved to Photos app")
                                            } else if let error = error {
                                                print("Error saving image to Photos app: \(error)")
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
                
                .padding()
                
                Button {
                    toggleFavorite()
                } label: {
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



