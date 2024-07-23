

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var url: String
    private var task: URLSessionDataTask?

    init(url: String) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: url) else { return }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
                if let image = image {
                    ImageCache.shared.set(image, forKey: self.url)
                }
            }
        }
        task?.resume()
    }
}


class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}


struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader

    init(url: String) {
        
            imageLoader = ImageLoader(url: url)
        
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
        }
    }
}





class ScrollViewModel: ObservableObject {
    @Published var scrollOffset: CGFloat = 0
    @Published var previousScrollOffset: CGFloat = 0
    @Published var isTabBarVisible: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $scrollOffset
            .combineLatest($previousScrollOffset)
            .map { currentOffset, previousOffset -> Bool in
                currentOffset <= previousOffset
            }
            .assign(to: \.isTabBarVisible, on: self)
            .store(in: &cancellables)
    }
    
    func updateScrollOffset(_ offset: CGFloat) {
        previousScrollOffset = scrollOffset
        scrollOffset = offset
    }
}
