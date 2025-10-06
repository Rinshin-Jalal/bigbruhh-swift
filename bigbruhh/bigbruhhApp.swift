//
//  bigbruhhApp.swift
//  bigbruhh
//
//  Created by Rinshin on 01/10/25.
//

import SwiftUI

@main
struct bigbruhhApp: App {
    // Initialize RevenueCat service
    @StateObject private var revenueCat = RevenueCatService.shared
    @StateObject private var authService = AuthService.shared

    init() {
        Config.log("🔥 BigBruh launching...", category: "App")
        Config.log("Supabase URL: \(Config.supabaseURL)", category: "Config")
        Config.log("RevenueCat Key: \(String(Config.revenueCatAPIKey.prefix(20)))...", category: "Config")

        // Clear in-progress onboarding state on app restart
        // Users must start onboarding from scratch each time
        OnboardingDataManager.shared.clearInProgressState()

        // RevenueCat is configured in RevenueCatService.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(OnboardingDataManager.shared)
                .environmentObject(revenueCat)
                .environmentObject(authService)
        }
    }
}
