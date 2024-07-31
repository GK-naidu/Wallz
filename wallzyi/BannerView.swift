import GoogleMobileAds
import SwiftUI

struct BannerContentView: View {
  var body: some View {
    BannerView()
  }
}

struct BannerContentView_Previews: PreviewProvider {
  static var previews: some View {
    BannerContentView()
  }
}

private struct BannerView: UIViewControllerRepresentable {
  @State private var viewWidth: CGFloat = .zero
  private let bannerView = GADBannerView()
  private let adUnitID = "ca-app-pub-3940256099942544/2435281174"

  func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = bannerViewController
    bannerView.delegate = context.coordinator
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    bannerViewController.view.addSubview(bannerView)
    
    // Add a rounded rectangle shape with a corner radius of 20
    bannerView.layer.cornerRadius = 20
    bannerView.layer.masksToBounds = true
    
    // Constrain GADBannerView to the bottom of the view.
    NSLayoutConstraint.activate([
      bannerView.bottomAnchor.constraint(
        equalTo: bannerViewController.view.safeAreaLayoutGuide.bottomAnchor),
      bannerView.centerXAnchor.constraint(equalTo: bannerViewController.view.centerXAnchor),
      bannerView.widthAnchor.constraint(equalToConstant: 320), // Fixed width
      bannerView.heightAnchor.constraint(equalToConstant: 50), // Fixed height
    ])
    bannerViewController.delegate = context.coordinator

    return bannerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }

    bannerView.load(GADRequest())
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  fileprivate class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate
  {
    let parent: BannerView

    init(_ parent: BannerView) {
      self.parent = parent
    }

    // MARK: - BannerViewControllerWidthDelegate methods

    func bannerViewController(
      _ bannerViewController: BannerViewController, didUpdate width: CGFloat
    ) {
      parent.viewWidth = width
    }

    // MARK: - GADBannerViewDelegate methods

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("DID RECEIVE AD")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("DID NOT RECEIVE AD: \(error.localizedDescription)")
    }
  }
}

protocol BannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {

  weak var delegate: BannerViewControllerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    delegate?.bannerViewController(
      self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate { _ in
      // do nothing
    } completion: { _ in
      self.delegate?.bannerViewController(
        self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
    }
  }
}
