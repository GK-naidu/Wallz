import SwiftUI

struct FullscreenImageView: View {
    let imageURLs: [URL]
    @Binding var currentIndex: Int
    @Binding var isFullscreen: Bool
    
    @State private var lightPosition: CGPoint = .zero
    @State private var velocity: CGSize = .zero
    @State private var lastUpdateTime: Date = Date()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    AsyncImage(url: imageURLs[currentIndex]) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            MetalEffectView(image: image, lightPosition: $lightPosition, velocity: $velocity)
                                
                                .frame(width: 400, height: 700)
                                .aspectRatio(contentMode: .fill)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let currentTime = Date()
                                            let timeDelta = currentTime.timeIntervalSince(lastUpdateTime)
                                            velocity = CGSize(
                                                width: (value.location.x - lightPosition.x) / CGFloat(timeDelta),
                                                height: (value.location.y - lightPosition.y) / CGFloat(timeDelta)
                                            )
                                            lightPosition = value.location
                                            lastUpdateTime = currentTime
                                        }
                                        .onEnded { _ in
                                            velocity = .zero
                                        }
                                )
                        case .failure:
                            Text("Failed to load image")
                                .foregroundColor(.white)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Text("Downloaded image would be higher in resolution")
                        .foregroundColor(.white)
                        .frame(width: 400)
                        .padding()
                }
            }
        }
        .statusBar(hidden: true)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    withAnimation(.default) {
                        isFullscreen = false
                    }
                }
        )
    }
}



