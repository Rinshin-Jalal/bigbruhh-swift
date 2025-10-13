//
//  WelcomeView.swift
//  bigbruhh
//
//  STEP 1 - Welcome Screen Implementation
//  Migrated from: nrn/components/WelcomeScreen.tsx
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var navigator: AppNavigator
    @State private var showCTA: Bool = false
    @State private var isLongPressing: Bool = false
    @State private var ctaOpacity: Double = 0.0

    var body: some View {
            ZStack {
                // Keep black background as requested
                Color.brutalBlack
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Main Content - Logo and Description in Middle
                    VStack(spacing: 20) {
                        // Header with logo - Full Width, Height scales with width
                        Image("logo-white-no-bg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)

                        // Subtitle
                        Text("Your accountability brother is here to help you stay on track.")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(Color(hex: "#888888"))
                            .multilineTextAlignment(.center)
                            .kerning(2)
                            .padding(.horizontal, 24)
                    }
                    
                    Spacer()

                    // Bottom Section - Button and Login
                    VStack(spacing: 24) {
                        // CTA Button - Using logo color (brutalRed)
                        if showCTA {
                            Button(action: handleStartTalking) {
                                Group {
                                    if #available(iOS 26, *) {
                                        Text(isLongPressing ? "CONNECTING..." : "START TALKING")
                                            .font(.system(size: 20, weight: .black, design: .default))
                                            .kerning(3)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 28)
                                            .glassEffect(
                                                .regular.tint(Color.brutalRed).interactive(),
                                                in: .rect(cornerRadius: 24)
                                            )
                                    } else {
                                        Text(isLongPressing ? "CONNECTING..." : "START TALKING")
                                            .font(.system(size: 20, weight: .black, design: .default))
                                            .kerning(3)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 28)
                                            .background(Color.brutalRed)
                                            .cornerRadius(24)
                                            .shadow(color: Color.brutalRed.opacity(0.3), radius: 12, x: 0, y: 6)
                                    }
                                }
                            }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        triggerHaptic(intensity: 0.3)
                                    }
                            )
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onEnded { _ in
                                        handleLongPress()
                                    }
                            )
                            .padding(.horizontal, 24)
                            .opacity(ctaOpacity)
                        }

                        // Secondary Action - Sign In Link
                        Button(action: handleSignIn) {
                            Text("Already have an account? Sign in")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(Color.white.opacity(0.7))
                                .kerning(0.5)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .onAppear {
                // Psychological timing effect - delayed CTA appearance (800ms creates tension)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showCTA = true
                    withAnimation(.easeIn(duration: 0.3)) {
                        ctaOpacity = 1.0
                    }
                }
            }
    }

    // MARK: - Actions

    private func handleLongPress() {
        triggerHaptic(intensity: 1.0)
        isLongPressing = true

        // Reset after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isLongPressing = false
        }
    }

    // MARK: - Haptics

    private func triggerHaptic(intensity: Double = 0.5) {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: intensity > 0.8 ? .heavy : .light)
        impact.impactOccurred()
        #endif
    }

    private func handleStartTalking() {
        print("🚀 START TALKING tapped - navigating to onboarding")
        triggerHaptic(intensity: 1.0)
        navigator.currentScreen = .onboarding
    }

    private func handleSignIn() {
        print("🔑 Sign in tapped")
        triggerHaptic(intensity: 0.3)
        navigator.showLogin()
    }
}

// MARK: - Preview

#Preview {
    WelcomeView()
}
