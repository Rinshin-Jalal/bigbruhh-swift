//
//  AlmostThereView.swift
//  bigbruhh
//
//  Created by Migration from React Native almost-there.tsx
//

import SwiftUI

struct AlmostThereView: View {
    @State private var navigateToHome = false
    @State private var navigateToPaywall = false
    @State private var currentStep: Int = 0
    @State private var showChoiceScreen: Bool = false

    // Development mode
    private var isDevelopment: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    // Confrontation steps - exactly matching React Native version
    private let confrontationSteps: [ConfrontationStep] = [
        ConfrontationStep(
            id: 1,
            prompt: "You answered.\n\nGood.\n\nThat call was a test.\n\nNow the real shit begins."
        ),
        ConfrontationStep(
            id: 2,
            prompt: "You just told me everything.\n\nYour excuses. Your fears. Your failures.\n\nI have it all.\n\nEvery night, I'll use it.\n\nAgainst you.\n\nUntil you change."
        ),
        ConfrontationStep(
            id: 3,
            prompt: "THIS ISN'T COACHING.\n\nTHIS IS WAR.\n\nAGAINST YOUR WEAK SELF.\n\nEVERY. SINGLE. NIGHT.\n\nYOU'LL HATE ME.\n\nGOOD."
        ),
        ConfrontationStep(
            id: 4,
            prompt: "I'll call when you're tired.\nWhen you're busy.\nWhen you failed.\n\nNo blocking.\nNo deleting.\nNo escape.\n\nOnce you pay, I own your accountability.\n\nForever.\n\nStill want this?"
        ),
        ConfrontationStep(
            id: 5,
            prompt: "LAST CHANCE TO RUN.\n\nPay = You're mine.\n\nEvery excuse counted.\nEvery failure tracked.\nEvery 'tomorrow' ends.\n\nCHOOSE:\n\nSTAY WEAK.\nOR PAY TO TRANSFORM."
        )
    ]

    // Colors matching React Native version
    private var backgroundColor: Color {
        return .black
    }

    private var textColor: Color {
        return .white
    }

    private var accentColor: Color {
        switch currentStep {
        case 1:
            return Color(hex: "#FF0000") // Red for step 2
        case 2:
            return Color(hex: "#FF4444") // Lighter red for step 3
        default:
            return Color(hex: "#90FD0E") // Green for other steps
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                if showChoiceScreen {
                    // Binary Choice Screen - Step 5
                    choiceScreenView
                } else {
                    // Explanation Steps 1-4
                    explanationStepView
                }

                // Debug button for development
                if isDevelopment {
                    VStack {
                        HStack {
                            Spacer()
                            Button("HOME") {
                                print("🔧 DEV: Going back to home page")
                                markAlmostThereCompleted()
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .padding(.trailing, 20)
                            .padding(.top, 60)
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
            .navigationDestination(isPresented: $navigateToPaywall) {
                // TODO: Create PaywallView
                Text("Paywall - Coming Soon")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
            }
        }
    }

    // MARK: - Explanation Step View (Steps 1-4)

    private var explanationStepView: some View {
        VStack(spacing: 0) {
            Spacer()

            Text(confrontationSteps[currentStep].prompt)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(textColor)
                .tracking(1.5)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            Spacer()
            Spacer()

            // Continue button (bottom right)
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button(action: handleNextStep) {
                        Text("NEXT →")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color.buttonTextColor(for: accentColor))
                            .tracking(1)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                    }
                    .applyStepGlassEffect(prominent: true, accentColor: accentColor)
                    .transition(.opacity.combined(with: .scale))
                    .padding(.trailing, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            // Trigger haptic on step appearance
            triggerHaptic(intensity: 1.0)
        }
    }

    // MARK: - Choice Screen View (Step 5)

    private var choiceScreenView: some View {
        HStack(spacing: 0) {
            // Left side - Stay Weak (Red)
            VStack {
                Spacer()

                Text("STAY WEAK\nSTAY THE SAME\nSTAY COMFORTABLE")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.white)
                    .tracking(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(0.5)

                Spacer()

                Button(action: handleLeave) {
                    Text("LEAVE")
                        .font(.system(size: 35, weight: .black))
                        .foregroundColor(.white)
                        .tracking(4)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#DC143C"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#DC143C"))

            // Right side - Pay The Price (Purple)
            VStack {
                Spacer()

                Text("PAY THE PRICE\nFACE THE TRUTH\nBECOME UNSTOPPABLE")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.white)
                    .tracking(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(0.5)

                Spacer()

                Button(action: handleCommit) {
                    Text("COMMIT")
                        .font(.system(size: 35, weight: .black))
                        .foregroundColor(.white)
                        .tracking(4)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#8B00FF"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#8B00FF"))
        }
    }

    // MARK: - Actions

    private func handleNextStep() {
        triggerHaptic(intensity: 1.0)

        if currentStep < 3 {
            // Steps 0-3: Advance to next explanation step
            currentStep += 1
        } else {
            // Step 4: Show choice screen
            showChoiceScreen = true
        }
    }

    private func handleLeave() {
        triggerHaptic(intensity: 1.0)
        print("User chose to LEAVE - marking almost there as completed and going home")
        markAlmostThereCompleted()
    }

    private func handleCommit() {
        triggerHaptic(intensity: 1.0)
        print("User chose to COMMIT - navigating to paywall")
        navigateToPaywall = true
    }

    private func markAlmostThereCompleted() {
        // TODO: Update user profile in Supabase to mark almostThereCompleted as true
        // For now, just navigate to home
        navigateToHome = true
        print("✅ Almost There flow completed - user can now access home")
    }

    // MARK: - Haptics

    private func triggerHaptic(intensity: Double = 0.5) {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: intensity > 0.8 ? .heavy : intensity > 0.5 ? .medium : .light)
        impact.impactOccurred()
        #endif
    }
}

// MARK: - Supporting Types

struct ConfrontationStep {
    let id: Int
    let prompt: String
}

// MARK: - Glass Effect Extensions

extension View {
    func applyStepGlassEffect(prominent: Bool = false, accentColor: Color) -> some View {
        if #available(iOS 26.0, *) {
            return self.glassEffect(.regular.tint(accentColor).interactive())
        } else {
            return self.background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

// Color extension is already defined in Shared/Theme/Colors.swift

// MARK: - Preview

#Preview {
    AlmostThereView()
}
