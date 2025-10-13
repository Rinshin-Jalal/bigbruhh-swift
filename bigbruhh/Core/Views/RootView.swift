//
//  RootView.swift
//  bigbruhh
//
//  Root-level view switcher - NO NESTING!
//

import SwiftUI
import Combine

enum AppScreen {
    case loading
    case welcome
    case onboarding
    case almostThere
    case paywall
    case secretPlan // Secret plan paywall $2.99/week starter
    case login // Login screen after payment
    case processing // Onboarding data push after payment
    case home
    case call
}

class AppNavigator: ObservableObject {
    @Published var currentScreen: AppScreen = .loading

    // Method to show paywall
    func showPaywall() {
        print("🔥🔥🔥 NAVIGATOR: SHOWING PAYWALL 🔥🔥🔥")
        currentScreen = .paywall
    }

    // Method to show processing (after payment & auth)
    func showProcessing() {
        print("⚙️⚙️⚙️ NAVIGATOR: SHOWING PROCESSING ⚙️⚙️⚙️")
        currentScreen = .processing
    }

    // Method to navigate to home
    func navigateToHome() {
        print("🏠🏠🏠 NAVIGATOR: NAVIGATING TO HOME 🏠🏠🏠")
        currentScreen = .home
    }

    // Legacy method (kept for compatibility)
    func showHome() {
        navigateToHome()
    }

    // Method to show secret plan paywall
    func showSecretPlan(userName: String? = nil, source: String = "quick_action") {
        print("🔒🔒🔒 NAVIGATOR: SHOWING SECRET PLAN PAYWALL 🔒🔒🔒")
        currentScreen = .secretPlan
    }


    // Method to show login screen
    func showLogin() {
        print("🔐🔐🔐 NAVIGATOR: SHOWING LOGIN SCREEN 🔐🔐🔐")
        currentScreen = .login
    }

    // Method to show onboarding with parameters
    func showOnboarding(userName: String, planType: String, source: String) {
        print("📝📝📝 NAVIGATOR: SHOWING ONBOARDING WITH PLAN TYPE: \(planType) 📝📝📝")
        currentScreen = .onboarding
    }

    // Method to show call screen
    func showCall() {
        print("📞📞📞 NAVIGATOR: SHOWING CALL SCREEN 📞📞📞")
        currentScreen = .call
    }
}

struct RootView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var navigator = AppNavigator()
    @ObservedObject private var brutalRealityManager = BrutalRealityManager.shared

    var body: some View {
        ZStack {
            switch navigator.currentScreen {
            case .loading:
                LoadingView()

            case .welcome:
                WelcomeView()
                    .environmentObject(navigator)

            case .onboarding:
                OnboardingView(onComplete: {
                    print("✅ Onboarding completed - navigating to AlmostThere")
                    navigator.currentScreen = .almostThere
                })

            case .almostThere:
                AlmostThereSimpleView()
                    .environmentObject(navigator)

            case .paywall:
                PaywallContainerView(source: "almost_there")
                    .environmentObject(navigator)

            case .secretPlan:
                SecretPlanPaywallView(
                    userName: "BigBruh", // TODO: Get from context
                    source: "quick_action"
                )
                .environmentObject(navigator)


            case .login:
                AuthView()
                    .environmentObject(navigator)

            case .processing:
                ProcessingView(onComplete: {
                    navigator.navigateToHome()
                })

            case .home:
                AuthGuard {
                    HomeView()
                        .environmentObject(navigator)
                }

            case .call:
                AuthGuard {
                    CallScreen()
                        .environmentObject(navigator)
                }
            }

            // Brutal Reality Overlay - appears over all screens when triggered
            if brutalRealityManager.showBrutalReality, let review = brutalRealityManager.todayReview {
                BrutalRealityMirrorView(
                    review: review,
                    onDismiss: {
                        brutalRealityManager.dismissBrutalReality()
                    }
                )
                .transition(.opacity)
                .zIndex(999) // Ensure it appears on top
            }
        }
        .environmentObject(navigator)
        .onAppear {
            print("🚀 RootView onAppear called")
            print("🚀 Current navigator screen: \(navigator.currentScreen)")
            print("🚀 AuthService state - loading: \(authService.loading), authenticated: \(authService.isAuthenticated)")
            determineInitialScreen()
            // Check for brutal reality triggers on app start
            brutalRealityManager.checkBrutalRealityFlags()
        }
        .onChange(of: authService.loading) { _, loading in
            print("🔄 AuthService loading changed to: \(loading)")
            if !loading {
                print("🔄 AuthService finished loading, determining screen...")
                determineInitialScreen()
            }
        }
        .onChange(of: authService.isAuthenticated) { _, isAuthenticated in
            print("🔄 AuthService isAuthenticated changed to: \(isAuthenticated)")
            // Only auto-navigate if we're not already in a specific screen
            // This prevents overriding manual navigation (like to ProcessingView)
            if navigator.currentScreen == .loading || navigator.currentScreen == .welcome {
                determineInitialScreen()
            }
        }
        .onChange(of: navigator.currentScreen) { _, newValue in
            print("🚨🚨🚨 CURRENT SCREEN CHANGED TO: \(newValue) 🚨🚨🚨")
        }
    }

    private func determineInitialScreen() {
        print("🔍 RootView: determineInitialScreen called")
        print("   authService.loading: \(authService.loading)")
        print("   authService.isAuthenticated: \(authService.isAuthenticated)")
        print("   Current navigator screen before: \(navigator.currentScreen)")

        // DEBUG: Commented out to allow proper auth flow
        // #if DEBUG
        // print("⚠️ DEBUG MODE: Going DIRECTLY to HOME")
        // navigator.currentScreen = .home
        // return
        // #endif

        if authService.loading {
            print("   → Setting screen to .loading")
            navigator.currentScreen = .loading
        } else if !authService.isAuthenticated {
            print("   → Setting screen to .welcome")
            navigator.currentScreen = .welcome
        } else {
            print("   → User authenticated, checking progress...")
            // Authenticated - check onboarding completion
            if authService.user?.onboardingCompleted == true {
                print("   → Onboarding completed - going to home")
                navigator.currentScreen = .home
            } else {
                print("   → Onboarding NOT completed - starting onboarding")
                navigator.currentScreen = .onboarding
            }
        }
        
        print("   → Final navigator screen: \(navigator.currentScreen)")
    }
}
