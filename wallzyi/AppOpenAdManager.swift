import UIKit
import GoogleMobileAds
import UserMessagingPlatform

protocol AppOpenAdManagerDelegate: AnyObject {
  /// Method to be invoked when an app open ad life cycle is complete (i.e. dismissed or fails to
  /// show).
  func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

class AppOpenAdManager: NSObject {
  /// Ad references in the app open beta will time out after four hours,
  /// but this time limit may change in future beta versions. For details, see:
  /// https://support.google.com/admob/answer/9341964?hl=en
  let timeoutInterval: TimeInterval = 1 * 3_600
  /// The app open ad.
  var appOpenAd: GADAppOpenAd?
  /// Maintains a reference to the delegate.
  weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
  /// Keeps track of if an app open ad is loading.
  var isLoadingAd = false
  /// Keeps track of if an app open ad is showing.
  var isShowingAd = false
  /// Keeps track of the time when an app open ad was loaded to discard expired ad.
  var loadTime: Date?

  static let shared = AppOpenAdManager()

  private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
    // Check if ad was loaded more than n hours ago.
    if let loadTime = loadTime {
      return Date().timeIntervalSince(loadTime) < timeoutInterval
    }
    return false
  }

  private func isAdAvailable() -> Bool {
    // Check if ad exists and can be shown.
    return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
  }

  private func appOpenAdManagerAdDidComplete() {
    // The app open ad is considered to be complete when it dismisses or fails to show,
    // call the delegate's appOpenAdManagerAdDidComplete method if the delegate is not nil.
    appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
  }

  func loadAd() async {
    // Do not load ad if there is an unused ad or one is already loading.
    if isLoadingAd || isAdAvailable() {
      return
    }
    isLoadingAd = true

    print("Start loading app open ad.")

    do {
      appOpenAd = try await GADAppOpenAd.load(
        withAdUnitID: "ca-app-pub-7497020872960760/7065957137", request: GADRequest())
      appOpenAd?.fullScreenContentDelegate = self
      loadTime = Date()
    } catch {
      appOpenAd = nil
      loadTime = nil
      print("App open ad failed to load with error: \(error.localizedDescription)")
    }
    isLoadingAd = false
  }

  func showAdIfAvailable() {
    // If the app open ad is already showing, do not show the ad again.
    if isShowingAd {
      print("App open ad is already showing.")
      return
    }
    // If the app open ad is not available yet but it is supposed to show,
    // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
    // method and load a new ad.
    if !isAdAvailable() {
      print("App open ad is not ready yet.")
      appOpenAdManagerAdDidComplete()
      if GoogleMobileAdsConsentManager.shared.canRequestAds {
        Task {
          await loadAd()
        }
      }
      return
    }
    if let ad = appOpenAd {
      print("App open ad will be displayed.")
      isShowingAd = true
      ad.present(fromRootViewController: nil)
    }
  }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("App open ad is will be presented.")
  }

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    appOpenAd = nil
    isShowingAd = false
    print("App open ad was dismissed.")
    appOpenAdManagerAdDidComplete()
    Task {
      await loadAd()
    }
  }

  func ad(
    _ ad: GADFullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    appOpenAd = nil
    isShowingAd = false
    print("App open ad failed to present with error: \(error.localizedDescription)")
    appOpenAdManagerAdDidComplete()
    Task {
      await loadAd()
    }
  }
}






class GoogleMobileAdsConsentManager: NSObject {
  static let shared = GoogleMobileAdsConsentManager()

  var canRequestAds: Bool {
    return UMPConsentInformation.sharedInstance.canRequestAds
  }

  var isPrivacyOptionsRequired: Bool {
    return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus == .required
  }

  /// Helper method to call the UMP SDK methods to request consent information and load/present a
  /// consent form if necessary.
  func gatherConsent(
    from consentFormPresentationviewController: UIViewController,
    consentGatheringComplete: @escaping (Error?) -> Void
  ) {
    let parameters = UMPRequestParameters()

    //For testing purposes, you can force a UMPDebugGeography of EEA or not EEA.
    let debugSettings = UMPDebugSettings()
    // debugSettings.geography = UMPDebugGeography.EEA
    parameters.debugSettings = debugSettings

    // Requesting an update to consent information should be called on every app launch.
    UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
      requestConsentError in
      guard requestConsentError == nil else {
        return consentGatheringComplete(requestConsentError)
      }

      UMPConsentForm.loadAndPresentIfRequired(from: consentFormPresentationviewController) {
        loadAndPresentError in

        // Consent has been gathered.
        consentGatheringComplete(loadAndPresentError)
      }
    }
  }

  /// Helper method to call the UMP SDK method to present the privacy options form.
  func presentPrivacyOptionsForm(
    from viewController: UIViewController, completionHandler: @escaping (Error?) -> Void
  ) {
    UMPConsentForm.presentPrivacyOptionsForm(
      from: viewController, completionHandler: completionHandler)
  }
}
