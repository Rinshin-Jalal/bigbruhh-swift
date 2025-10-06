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
    
    // Method to show home
    func showHome() {
        print("🏠🏠🏠 NAVIGATOR: SHOWING HOME 🏠🏠🏠")
        currentScreen = .home
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

            case .home:
                HomeView()
                    .environmentObject(navigator)

            case .call:
                CallScreen()
                    .environmentObject(navigator)
            }
        }
        .onAppear {
            determineInitialScreen()
        }
        .onChange(of: authService.isAuthenticated) { _ in
            determineInitialScreen()
        }
        .onChange(of: navigator.currentScreen) { newValue in
            print("🚨🚨🚨 CURRENT SCREEN CHANGED TO: \(newValue) 🚨🚨🚨")
        }
    }

    private func determineInitialScreen() {
        print("🔍 RootView: determineInitialScreen called")
        print("   authService.loading: \(authService.loading)")
        print("   authService.isAuthenticated: \(authService.isAuthenticated)")

        // TEMP FIX: Skip auth for now, go straight to HOME for testing
        #if DEBUG
        print("⚠️ DEBUG MODE: Going DIRECTLY to HOME")
        navigator.currentScreen = .home
        return
        #endif

        if authService.loading {
            print("   → Setting screen to .loading")
            navigator.currentScreen = .loading
        } else if !authService.isAuthenticated {
            print("   → Setting screen to .welcome")
            navigator.currentScreen = .welcome
        } else {
            print("   → User authenticated, checking progress...")
            // Authenticated - check progress
            if authService.user?.onboardingCompleted == true {
                if authService.user?.almostThereCompleted == true {
                    navigator.currentScreen = .home
                } else {
                    navigator.currentScreen = .almostThere
                }
            } else {
                navigator.currentScreen = .onboarding
            }
        }
    }
}
