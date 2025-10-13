//
//  BrutalRealityMirrorView.swift
//  bigbruhh
//
//  Full-screen brutal reality display with dynamic animations and effects
//

import SwiftUI
import AudioToolbox
import UIKit

struct BrutalRealityMirrorView: View {
    let review: BrutalRealityReview
    let onDismiss: () -> Void

    @State private var canDismiss = false
    @State private var isReading = true
    @State private var startTime = Date()

    // Animation states
    @State private var backgroundOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var glitchOffset: CGFloat = 0
    @State private var remainingTime: Int = 0

    private let colors: BrutalRealityColorTheme
    private let brutalText: String
    private let effects: EmotionEffects
    private let readingTime: Int

    init(review: BrutalRealityReview, onDismiss: @escaping () -> Void) {
        self.review = review
        self.onDismiss = onDismiss

        self.colors = review.colorTheme
        self.brutalText = review.brutalParagraph
        self.effects = EmotionEffects.from(emotion: review.dominantEmotion, impactScore: review.psychologicalImpactScore)
        self.readingTime = max(8000, review.psychologicalImpactScore * 100) / 1000 // Convert to seconds
    }

    var body: some View {
        ZStack {
            // Background with dynamic colors and animations
            Color(hex: colors.primary)
                .opacity(backgroundOpacity)
                .scaleEffect(effects.shouldPulse ? pulseScale : 1.0)
                .animation(.easeInOut(duration: 1.5), value: backgroundOpacity)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Psychological Impact Score and Emotion
                VStack(spacing: 8) {
                    Text("Impact: \(review.psychologicalImpactScore)/100")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: colors.text).opacity(0.7))

                    Text(review.dominantEmotion.uppercased())
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: colors.accent))
                        .letterSpacing(1)
                }
                .padding(.bottom, 50)

                // The brutal paragraph - main focus
                Text(brutalText)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color(hex: colors.text))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .opacity(textOpacity)
                    .offset(x: effects.shouldGlitch ? glitchOffset : 0)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 50)
                    .animation(.easeInOut(duration: 2.0), value: textOpacity)

                Spacer()

                // Dismiss button - only appears after reading time
                if canDismiss {
                    Button(action: handleDismiss) {
                        Text(isReading ? "FACE REALITY" : "ACCEPT CONSEQUENCES")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: colors.text))
                            .padding(.vertical, 20)
                            .padding(.horizontal, 40)
                            .background(Color(hex: colors.secondary))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: colors.accent), lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 80)
                }

                // Reading timer indicator
                if !canDismiss {
                    Text("Processing reality... \(remainingTime)s")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: colors.accent).opacity(0.8))
                        .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Start background animation
        withAnimation(.easeInOut(duration: 1.5)) {
            backgroundOpacity = 1.0
        }

        // Fade in text slowly to force reading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 2.0)) {
                textOpacity = 1.0
            }
        }

        // Dynamic effects based on AI emotion analysis
        if effects.shouldPulse {
            startPulsingAnimation()
        }

        if effects.shouldGlitch {
            startGlitchAnimation()
        }

        // Haptic feedback
        triggerHapticFeedback()

        // Start reading timer
        startReadingTimer()
    }

    private func startPulsingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.8)) {
                pulseScale = pulseScale == 1.0 ? 1.02 : 1.0
            }
        }
    }

    private func startGlitchAnimation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            let glitchDuration = 0.3
            glitchOffset = 2

            DispatchQueue.main.asyncAfter(deadline: .now() + glitchDuration) {
                glitchOffset = -2

                DispatchQueue.main.asyncAfter(deadline: .now() + glitchDuration) {
                    glitchOffset = 0
                }
            }
        }
    }

    private func triggerHapticFeedback() {
        // Heavy impact on start
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        // Vibration based on psychological impact
        if effects.shouldVibrate {
            let intensity = review.psychologicalImpactScore > 80
                ? [500, 200, 500, 200, 500]
                : [300, 150, 300]

            for (index, duration) in intensity.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.7) {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
        }
    }

    private func startReadingTimer() {
        remainingTime = readingTime

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            remainingTime -= 1

            if remainingTime <= 0 {
                timer.invalidate()
                canDismiss = true
                isReading = false
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }

    private func handleDismiss() {
        if !canDismiss { return }

        // Haptic feedback
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        onDismiss()
    }
}

// MARK: - Supporting Types

struct EmotionEffects {
    let shouldPulse: Bool
    let shouldVibrate: Bool
    let shouldGlitch: Bool

    static func from(emotion: String, impactScore: Int) -> EmotionEffects {
        let intensity = Double(impactScore) / 100.0

        switch emotion.lowercased() {
        case "shame":
            return EmotionEffects(
                shouldPulse: intensity > 0.7,
                shouldVibrate: intensity > 0.8,
                shouldGlitch: false
            )
        case "rage":
            return EmotionEffects(
                shouldPulse: true,
                shouldVibrate: intensity > 0.6,
                shouldGlitch: intensity > 0.9
            )
        case "despair":
            return EmotionEffects(
                shouldPulse: false,
                shouldVibrate: false,
                shouldGlitch: intensity > 0.8
            )
        case "denial":
            return EmotionEffects(
                shouldPulse: false,
                shouldVibrate: false,
                shouldGlitch: intensity > 0.7
            )
        default:
            return EmotionEffects(
                shouldPulse: intensity > 0.8,
                shouldVibrate: intensity > 0.9,
                shouldGlitch: false
            )
        }
    }
}

