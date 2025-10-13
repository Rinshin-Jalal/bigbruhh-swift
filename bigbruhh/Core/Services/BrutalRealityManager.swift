//
//  BrutalRealityManager.swift
//  bigbruhh
//
//  Manager for handling brutal reality state and triggers (like Provider in RN)
//

import Foundation
import Combine

class BrutalRealityManager: ObservableObject {
    static let shared = BrutalRealityManager()

    @Published var showBrutalReality: Bool = false
    @Published var todayReview: BrutalRealityReview?

    private let triggerBrutalRealityKey = "trigger_brutal_reality"

    private init() {
        checkBrutalRealityFlags()
    }

    // MARK: - Public Methods

    func dismissBrutalReality() {
        showBrutalReality = false
        todayReview = nil
    }

    func checkBrutalRealityFlags() {
        Task {
            await checkBrutalRealityFlagsAsync()
        }
    }

        func triggerBrutalRealityManually() {
            // For testing - manually trigger brutal reality
            Task {
                do {
                    let response = try await APIService.shared.getTodayBrutalReality()
                    if response.success, let brutalReality = response.data {
                        await MainActor.run {
                            todayReview = brutalReality
                            showBrutalReality = true
                        }
                        Config.log("✅ Manually triggered brutal reality from API", category: "BrutalReality")
                    } else {
                        // Fallback to mock data
                        await MainActor.run {
                            todayReview = createMockBrutalReality()
                            showBrutalReality = true
                        }
                        Config.log("✅ Manually triggered brutal reality (mock)", category: "BrutalReality")
                    }
                } catch {
                    Config.log("❌ Failed to manually trigger brutal reality: \(error)", category: "BrutalReality")
                    // Fallback to mock data
                    await MainActor.run {
                        todayReview = createMockBrutalReality()
                        showBrutalReality = true
                    }
                    Config.log("✅ Manually triggered brutal reality (fallback mock)", category: "BrutalReality")
                }
            }
        }

    // MARK: - Private Methods

        private func checkBrutalRealityFlagsAsync() async {
            do {
                // Check for brutal reality trigger from AsyncStorage/UserDefaults
                let brutalRealityFlag: String? = UserDefaultsManager.get(triggerBrutalRealityKey)

                // Check for brutal reality trigger
                if let triggerDataString = brutalRealityFlag {
                    Config.log("💀 Brutal reality trigger detected - loading today's review", category: "BrutalReality")

                    do {
                        if let triggerData = try JSONSerialization.jsonObject(with: Data(triggerDataString.utf8), options: []) as? [String: Any],
                           let triggerBrutalReality = triggerData["triggerBrutalReality"] as? Bool,
                           triggerBrutalReality {

                            // Load today's brutal reality from API
                            let response = try await APIService.shared.getTodayBrutalReality()

                            if response.success, let brutalReality = response.data {
                                await MainActor.run {
                                    todayReview = brutalReality
                                    showBrutalReality = true
                                }

                                // Clear the trigger
                                UserDefaultsManager.remove(forKey: triggerBrutalRealityKey)
                                Config.log("✅ Loaded brutal reality review", category: "BrutalReality")
                            } else {
                                Config.log("❌ Failed to load brutal reality: \(response.error ?? "Unknown error")", category: "BrutalReality")
                                
                                // Fallback: Create mock brutal reality for testing
                                await MainActor.run {
                                    todayReview = createMockBrutalReality()
                                    showBrutalReality = true
                                }
                                UserDefaultsManager.remove(forKey: triggerBrutalRealityKey)
                            }
                        }
                    } catch {
                        Config.log("❌ Failed to parse brutal reality trigger: \(error)", category: "BrutalReality")
                        // Clear corrupted data
                        UserDefaultsManager.remove(forKey: triggerBrutalRealityKey)
                    }
                }
            } catch {
                Config.log("⚠️ Failed to check brutal reality flags: \(error)", category: "BrutalReality")
            }
        }
        
        private func createMockBrutalReality() -> BrutalRealityReview {
            return BrutalRealityReview(
                id: UUID().uuidString,
                brutalParagraph: "You thought you could escape, didn't you? Another day, another set of broken promises. The mirror doesn't lie, and neither do your actions. This is the reality you've created.",
                psychologicalImpactScore: 85,
                dominantEmotion: "shame",
                colorTheme: BrutalRealityColorTheme(primary: "#2d2008", secondary: "#5c4a15", accent: "#8a7228", text: "#fff5e6"),
                patternIdentified: "chronic_avoidance",
                readingTimeSeconds: 10,
                reviewDate: Date(),
                createdAt: Date()
            )
        }
}
