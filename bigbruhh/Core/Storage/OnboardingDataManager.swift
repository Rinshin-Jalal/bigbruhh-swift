//
//  OnboardingDataManager.swift
//  BigBruh
//
//  Manages completed onboarding data that can be accessed across the app
//  (Paywall, Signup, etc.) without resuming in-progress onboarding state
//

import Foundation
import Combine

class OnboardingDataManager: ObservableObject {
    static let shared = OnboardingDataManager()

    // MARK: - Keys

    private enum Keys {
        static let completedOnboardingData = "completed_onboarding_data"
        static let inProgressState = "onboarding_v3_state"
    }

    // MARK: - Published Properties

    @Published var completedData: OnboardingState?

    // MARK: - Initialization

    private init() {
        loadCompletedData()
    }

    // MARK: - Public Methods

    /// Save completed onboarding data (called when user finishes all 45 steps)
    func saveCompletedData(_ state: OnboardingState) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(state) {
            UserDefaults.standard.set(encoded, forKey: Keys.completedOnboardingData)
            print("💾 Completed onboarding data saved")
            loadCompletedData() // Update published property
        }
    }

    /// Load completed onboarding data from storage
    func loadCompletedData() {
        if let savedData = UserDefaults.standard.data(forKey: Keys.completedOnboardingData),
           let decoded = try? JSONDecoder().decode(OnboardingState.self, from: savedData) {
            completedData = decoded
            print("📂 Completed onboarding data loaded")
        }
    }

    /// Clear in-progress onboarding state (call on app init to force fresh start)
    func clearInProgressState() {
        UserDefaults.standard.removeObject(forKey: Keys.inProgressState)
        print("🧹 In-progress onboarding state cleared - user will start fresh")
    }

    /// Clear all onboarding data (for logout/reset)
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: Keys.completedOnboardingData)
        UserDefaults.standard.removeObject(forKey: Keys.inProgressState)
        completedData = nil
        print("🗑️ All onboarding data cleared")
    }

    // MARK: - Computed Properties for Quick Access

    var userName: String? {
        return completedData?.userName
    }

    var brotherName: String {
        return completedData?.brotherName ?? ""
    }

    var allResponses: [Int: UserResponse] {
        return completedData?.responses ?? [:]
    }

    func getResponse(for stepId: Int) -> UserResponse? {
        return completedData?.responses[stepId]
    }

    // Get all voice responses (with base64 audio data)
    var voiceResponses: [UserResponse] {
        return allResponses.values.filter { $0.type == .voice }
    }

    // Get all text responses
    var textResponses: [UserResponse] {
        return allResponses.values.filter { $0.type == .text }
    }

    // Check if onboarding was completed
    var hasCompletedOnboarding: Bool {
        return completedData?.isCompleted ?? false
    }
}
