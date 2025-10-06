//
//  PaywallView.swift
//  bigbruhh
//
//  Main paywall container - wraps RevenueCat paywall with navigation logic
//

import SwiftUI

struct PaywallContainerView: View {
    @EnvironmentObject var navigator: AppNavigator
    @EnvironmentObject var onboardingData: OnboardingDataManager
    @EnvironmentObject var revenueCat: RevenueCatService
    @Environment(\.dismiss) private var dismiss

    let source: String

    init(source: String = "unknown") {
        self.source = source
    }

    var body: some View {
        RevenueCatPaywallView(
            source: source,
            onPurchaseComplete: {
                handlePurchaseComplete()
            },
            onDismiss: {
                handleDismiss()
            }
        )
        .environmentObject(revenueCat)
        .onAppear {
            print("🚨🚨🚨 PAYWALL VIEW APPEARED! 🚨🚨🚨")
            debugPrintOnboardingData()
        }
    }

    // MARK: - Handlers

    private func handlePurchaseComplete() {
        print("✅ Purchase completed - navigating to home")

        // Navigate to home after purchase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            navigator.showHome()
        }
    }

    private func handleDismiss() {
        print("👋 User declined paywall")
        // Go back to previous screen (almostThere)
        navigator.currentScreen = .almostThere
        dismiss()
    }

    // MARK: - Debug Helper

    private func debugPrintOnboardingData() {
        print("\n💳 === PAYWALL: Onboarding Data Access ===")
        print("👤 User Name: \(onboardingData.userName ?? "N/A")")
        print("🤝 Brother Name: \(onboardingData.brotherName)")
        print("📊 Total Responses: \(onboardingData.allResponses.count)")
        print("🎤 Voice Responses: \(onboardingData.voiceResponses.count)")
        print("📝 Text Responses: \(onboardingData.textResponses.count)")

        // Print all voice recordings (base64 data URLs)
        for voiceResponse in onboardingData.voiceResponses {
            print("  🎙️  Step \(voiceResponse.stepId): \(voiceResponse.duration ?? 0)s")
        }
        print("💳 ================================\n")
    }
}

// MARK: - Preview

#Preview {
    PaywallContainerView()
        .environmentObject(OnboardingDataManager.shared)
}
