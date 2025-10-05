//
//  AuthView.swift
//  BigBruh
//
//  Authentication screen matching nrn/app/(auth)/auth.tsx

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @StateObject private var authService = AuthService.shared
    @State private var signingIn = false

    // Animation states
    @State private var fadeInOpacity: Double = 0
    @State private var slideUpOffset: CGFloat = 50
    @State private var buttonGlowScale: CGFloat = 1.0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Background
            Color.brutalBlack
                .ignoresSafeArea()

            if authService.loading {
                loadingView
            } else {
                mainContent
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .tint(.brutalRedLight)
                .scaleEffect(1.5)

            Text("Initializing...")
                .font(.bodyBold)
                .foregroundColor(.white)
                .opacity(0.8)
        }
        .scaleEffect(pulseScale)
    }

    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: 0) {
            Spacer()

            // Header
            VStack(spacing: Spacing.md) {
                Text("BIG BRUH")
                    .font(.headline)
                    .foregroundColor(.brutalRedLight)
                    .brutalStyle()
                    .scaleEffect(pulseScale)

                Text("Your transformation awaits.")
                    .font(.title)
                    .foregroundColor(.white)
                    .opacity(0.9)

                Text("No more excuses. No more weakness.")
                    .font(.bodyRegular)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            .padding(.top, 60)
            .opacity(fadeInOpacity)

            Spacer()

            // Auth Button
            VStack(spacing: Spacing.xl) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        handleAppleSignIn(result)
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: Spacing.buttonHeightLarge)
                .cornerRadius(Spacing.radiusMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                        .stroke(Color.white, lineWidth: Spacing.borderMedium)
                )
                .shadow(color: Color.white.opacity(0.2), radius: 8)
                .scaleEffect(buttonGlowScale)
                .disabled(signingIn)

                if signingIn {
                    ProgressView()
                        .tint(.white)
                }
            }
            .padding(.horizontal, Spacing.xxl)
            .padding(.vertical, Spacing.xxxl)
            .opacity(fadeInOpacity)
            .offset(y: slideUpOffset)

            Spacer()

            // Footer
            Text("By continuing, you accept our Terms & transform your life.")
                .font(.captionSmall)
                .foregroundColor(.white)
                .opacity(0.5)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
                .padding(.bottom, Spacing.xl)
                .opacity(fadeInOpacity)
        }
    }

    // MARK: - Animations
    private func startAnimations() {
        withAnimation(AnimationPresets.fadeIn) {
            fadeInOpacity = 1
        }

        withAnimation(AnimationPresets.slideUp) {
            slideUpOffset = 0
        }

        withAnimation(AnimationPresets.buttonGlow) {
            buttonGlowScale = 1.02
        }

        withAnimation(AnimationPresets.pulse) {
            pulseScale = 1.005
        }
    }

    // MARK: - Apple Sign In Handler
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success:
            HapticManager.medium()
            signingIn = true

            Task {
                do {
                    try await authService.signInWithApple()
                    HapticManager.triggerNotification(.success)
                    Config.log("Apple sign in successful", category: "Auth")
                } catch {
                    HapticManager.triggerNotification(.error)
                    Config.log("Apple sign in failed: \(error)", category: "Auth")
                    signingIn = false
                }
            }

        case .failure(let error):
            Config.log("Apple sign in cancelled or failed: \(error)", category: "Auth")
            signingIn = false
        }
    }
}

// MARK: - Preview
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
