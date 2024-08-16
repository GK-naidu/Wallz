import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct wallzApp: App {
    @StateObject private var userSettings = UserSettings()
    @State private var showCustomDialog = false  // Start with false, set true after intro screens
    @State private var showIntroScreens = true  // Initially set to true to show intro screens

    var body: some Scene {
        WindowGroup {
            if showIntroScreens && userSettings.isFirstLaunch && !userSettings.hasSeenIntroScreens {
                IntroScreensView(showIntroScreens: $showIntroScreens)
                    .onDisappear {
                        userSettings.markIntroScreensAsSeen()
                        showCustomDialog = true  // Show the tracking dialog after intro screens
                    }
            } else {
                NavigationStack {
                    TabBarTest()
                        .overlay(
                            CustomTrackingDialog(
                                isActive: $showCustomDialog,
                                action: {
                                    requestIDFA()  // Trigger the ATT prompt after the user agrees
                                }
                            )
                            .opacity(showCustomDialog && !userSettings.hasShownTrackingDialog ? 1 : 0)
                        )
                        .onAppear {
                            handleAppOpenAd()  // Handle app open ad when the app appears
                        }
                }
            }
        }
    }

    func requestIDFA() {
        ATTrackingManager.requestTrackingAuthorization { status in
            userSettings.markTrackingDialogAsShown()  // Mark that the dialog has been shown
            showCustomDialog = false  // Hide the dialog after the user makes a choice
            switch status {
            case .authorized:
                print("ATT: Tracking authorized")
                Task {
                    await AppOpenAdManager.shared.loadAd()  // Load the app open ad asynchronously
                }
                userSettings.completeIDFA()
            case .denied, .restricted, .notDetermined:
                print("ATT: Tracking denied/restricted/not determined")
                userSettings.completeIDFA()
            @unknown default:
                print("ATT: Unknown status")
                userSettings.completeIDFA()
            }
        }
    }

    func handleAppOpenAd() {
        if userSettings.hasCompletedIDFA {
            AppOpenAdManager.shared.showAdIfAvailable()
        }
    }
}

