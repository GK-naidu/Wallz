//import GoogleMobileAds
//
//class InterstitialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
//    
//    // Properties
//    @Published var interstitialAdLoaded: Bool = false
//    var interstitialAd: GADInterstitialAd?
//    private var adDismissedCompletion: (() -> Void)?
//    
//    override init() {
//        super.init()
//        loadInterstitialAd()
//    }
//    
//    // Load InterstitialAd
//    func loadInterstitialAd() {
//        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-7497020872960760/7720785028", request: GADRequest()) { [weak self] add, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("🔴: \(error.localizedDescription)")
//                self.interstitialAdLoaded = false
//                return
//            }
//            print("🟢: Loading succeeded")
//            self.interstitialAdLoaded = true
//            self.interstitialAd = add
//            self.interstitialAd?.fullScreenContentDelegate = self
//        }
//    }
//    
//    // Display InterstitialAd
//    func displayInterstitialAd(completion: @escaping () -> Void) {
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        guard let root = windowScene?.windows.first?.rootViewController else {
//            completion()
//            return
//        }
//        if let add = interstitialAd {
//            adDismissedCompletion = completion
//            add.present(fromRootViewController: root)
//            self.interstitialAdLoaded = false
//        } else {
//            print("🔵: Ad wasn't ready")
//            self.interstitialAdLoaded = false
//            self.loadInterstitialAd()
//            completion()
//        }
//    }
//    
//    // Failure notification
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("🟡: Failed to display interstitial ad")
//        self.loadInterstitialAd()
//        adDismissedCompletion?()
//        adDismissedCompletion = nil
//    }
//    
//    // Indicate notification
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("🤩: Displayed an interstitial ad")
//        self.interstitialAdLoaded = false
//    }
//    
//    // Close notification
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("😔: Interstitial ad closed")
//        self.loadInterstitialAd()
//        adDismissedCompletion?()
//        adDismissedCompletion = nil
//    }
//}
