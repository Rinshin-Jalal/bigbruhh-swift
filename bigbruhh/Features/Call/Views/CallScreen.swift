//
//  CallScreen.swift
//  bigbruhh
//
//  AI-powered accountability call screen with mood-based animations
//

import SwiftUI

struct CallScreen: View {
    @EnvironmentObject var navigator: AppNavigator
    @State private var callStarted = false
    @State private var elapsed: String = "00:00"
    @State private var muted = false
    @State private var showTextInput = false
    @State private var messageText = ""
    @State private var liveText = "Connecting to your accountability system..."
    @State private var typedText = ""
    @State private var currentMood: CallMood = .calm
    @State private var moodIntensity: Double = 0.0
    @State private var shakeOffset: CGFloat = 0
    @State private var shameMode: ShameType? = nil
    @State private var shameScale: CGFloat = 0
    @State private var startTime: Date?
    @State private var typingAnimation: [Bool] = [false, false, false]

    enum CallMood {
        case calm, angry, nuclear, disappointed

        var backgroundColor: Color {
            switch self {
            case .calm:
                return Color(hex: "#000000")  // black
            case .angry:
                return Color(hex: "#DC143C")  // red (matches home)
            case .disappointed:
                return Color(hex: "#8B00FF")  // purple (matches home)
            case .nuclear:
                return Color(hex: "#FF8C00")  // orange (matches home)
            }
        }
    }

    enum ShameType {
        case brokenPromises, excusePattern, bigbruh
    }

    var body: some View {
        ZStack {
            // Solid background based on mood
            currentMood.backgroundColor
                .opacity(1.0 + moodIntensity * 0.2)
                .ignoresSafeArea()
                .offset(x: shakeOffset)
                .animation(.easeInOut(duration: 1.0), value: currentMood)

            VStack(spacing: 0) {
                // Title and Timer
                titleSection
                    .padding(.top, 60)

                Spacer()

                // Live AI Text
                liveTextSection
                    .padding(.horizontal, 20)

                Spacer()

                // Text Input (if shown)
                if showTextInput {
                    textInputSection
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Control Buttons
                controlButtons
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            startCall()
        }
    }

    // MARK: - Title Section

    private var titleSection: some View {
        VStack(spacing: 16) {
            // Huge minimal timer
            Text(elapsed)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .tracking(12)
                .monospacedDigit()

        }
    }

    // MARK: - Live Text Section

    private var liveTextSection: some View {
        VStack {
            if let shame = shameMode {
                shameDisplay(type: shame)
            } else {
                Group {
                    if #available(iOS 26.0, *) {
                        liveTextGlass
                    } else {
                        liveTextFallback
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    @available(iOS 26.0, *)
    private var liveTextGlass: some View {
        Text(typedText.isEmpty ? "you're on the record" : typedText)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(typedText.isEmpty ? Color(hex: "#90FD0E").opacity(0.6) : .white)
            .tracking(0.3)
            .lineSpacing(6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
    }

    private var liveTextFallback: some View {
        Text(typedText.isEmpty ? "you're on the record" : typedText)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(typedText.isEmpty ? Color(hex: "#90FD0E").opacity(0.6) : .white)
            .tracking(0.3)
            .lineSpacing(6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color(hex: "#90FD0E").opacity(0.2), lineWidth: 1)
            )
    }

    private func shameDisplay(type: ShameType) -> some View {
        Group {
            if #available(iOS 26.0, *) {
                shameDisplayGlass(type: type)
            } else {
                shameDisplayFallback(type: type)
            }
        }
    }

    @available(iOS 26.0, *)
    private func shameDisplayGlass(type: ShameType) -> some View {
        VStack(spacing: 16) {
            Text(typedText)
                .font(.system(size: type == .bigbruh ? 24 : 20, weight: .black))
                .foregroundColor(.white)
                .tracking(3)
                .multilineTextAlignment(.leading)
                .scaleEffect(shameScale)
                .padding(.horizontal, 28)
                .padding(.vertical, 20)

            if type == .bigbruh {
                Text("YOU CANNOT HIDE FROM YOUR FAILURES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "#FF4444"))
                    .tracking(1.5)
            }
        }
        .padding(.horizontal, 20)
    }

    private func shameDisplayFallback(type: ShameType) -> some View {
        VStack(spacing: 16) {
            Text(typedText)
                .font(.system(size: type == .bigbruh ? 24 : 20, weight: .black))
                .foregroundColor(.white)
                .tracking(3)
                .multilineTextAlignment(.leading)
                .scaleEffect(shameScale)
                .padding(.horizontal, 28)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(hex: "#DC143C"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(Color(hex: "#FF4444").opacity(0.4), lineWidth: 2)
                )
                .shadow(color: Color(hex: "#DC143C").opacity(0.8), radius: 30, x: 0, y: 0)
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)

            if type == .bigbruh {
                Text("YOU CANNOT HIDE FROM YOUR FAILURES")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "#FF4444"))
                    .tracking(1.5)
                    .textCase(.uppercase)
            }
        }
    }

    // MARK: - Text Input Section

    private var textInputSection: some View {
        Group {
            if #available(iOS 26.0, *) {
                textInputGlass
            } else {
                textInputFallback
            }
        }
    }

    @available(iOS 26.0, *)
    private var textInputGlass: some View {
        GlassEffectContainer {
            HStack(alignment: .bottom, spacing: 12) {
                TextField("Type message to BigBruh...", text: $messageText, axis: .vertical)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(14)
                    .lineLimit(1...4)        
                .glassEffect(in: .rect(cornerRadius: 20))


                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                }
                .glassEffect(.regular.tint(Color.white).interactive())
            }.padding(.horizontal, 20)
        }
    }

    private var textInputFallback: some View {
        HStack(alignment: .bottom, spacing: 12) {
            TextField("Type message to BigBruh...", text: $messageText, axis: .vertical)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(14)
                .lineLimit(1...4)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                )

            Button(action: sendMessage) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .padding(.top, 12)
        .background(.black.opacity(0.3))
    }

    // MARK: - Control Buttons (Native iOS Call Style with iOS 26 Liquid Glass)

    private var controlButtons: some View {
        Group {
            if #available(iOS 26.0, *) {
                glassButtons
            } else {
                fallbackButtons
            }
        }
    }

    @available(iOS 26.0, *)
    private var glassButtons: some View {
        HStack(spacing: 24) {
            // Mute Button
            Button(action: toggleMute) {
                    Image(systemName: muted ? "mic.slash.fill" : "mic.fill")
                        .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)
            .glassEffect(.regular.tint(Color.black.opacity(0.2)).interactive())

            // Message Button
            Button(action: toggleTextInput) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)
            .glassEffect(.regular.tint(Color.black.opacity(0.2)).interactive())

            // End Call Button
            Button(action: endCall) {
            Image(systemName: "phone.down.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)
            .glassEffect(.regular.tint(Color(hex: "#DC143C")).interactive())
        }
    }

    private var fallbackButtons: some View {
        HStack(spacing: 50) {
            // Mute Button
            VStack(spacing: 8) {
                Button(action: toggleMute) {
                    Image(systemName: muted ? "mic.slash.fill" : "mic.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        )
                }

                Text("mute")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .textCase(.lowercase)
            }

            // Message Button
            VStack(spacing: 8) {
                Button(action: toggleTextInput) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        )
                }

                Text("message")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .textCase(.lowercase)
            }

            // End Call Button
            VStack(spacing: 8) {
                Button(action: endCall) {
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            Circle()
                                .fill(Color(hex: "#DC143C"))
                        )
                }

                Text("end")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .textCase(.lowercase)
            }
        }
    }

    // MARK: - Actions

    private func startCall() {
        callStarted = true
        startTime = Date()

        // Start timer
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard let start = startTime else { return }
            let ms = Date().timeIntervalSince(start)
            let totalSeconds = Int(ms)
            let m = String(format: "%02d", totalSeconds / 60)
            let s = String(format: "%02d", totalSeconds % 60)
            elapsed = "\(m):\(s)"
        }

        // Start typing animation
        for index in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                typingAnimation[index] = true
            }
        }

        // Typewriter effect
        typewriterEffect(text: liveText)

        // Demo: Cycle through all moods - black → red → purple → orange → loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            changeMood(to: .angry, intensity: 0.5)
            typewriterEffect(text: "Let's talk about those broken promises...")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            changeMood(to: .disappointed, intensity: 0.6)
            typewriterEffect(text: "I expected better from you...")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            changeMood(to: .nuclear, intensity: 0.8)
            typewriterEffect(text: "THIS IS YOUR FINAL WARNING")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            changeMood(to: .calm, intensity: 0.0)
            typewriterEffect(text: "Okay... let's start over...")
        }

        // Loop back to angry
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            changeMood(to: .angry, intensity: 0.5)
            typewriterEffect(text: "Let's talk about those broken promises...")
        }
    }

    private func toggleMute() {
        muted.toggle()
    }

    private func toggleTextInput() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showTextInput.toggle()
        }
        if !showTextInput {
            messageText = ""
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        liveText = "You: \(messageText)"
        typewriterEffect(text: liveText)
        messageText = ""
    }

    private func endCall() {
        callStarted = false
        navigator.showHome()
    }

    // MARK: - Effects

    private func typewriterEffect(text: String) {
        typedText = ""
        let characters = Array(text)
        for (index, char) in characters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                typedText.append(char)
            }
        }
    }

    private func changeMood(to mood: CallMood, intensity: Double) {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentMood = mood
            moodIntensity = intensity
        }

        // Screen shake
        let shakePattern: [CGFloat] = [-20, 20, -15, 15, -10, 10, -5, 5, 0]
        for (index, offset) in shakePattern.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.linear(duration: 0.05)) {
                    shakeOffset = offset * CGFloat(intensity)
                }
            }
        }
    }

    private func showShame(message: String, type: ShameType) {
        liveText = message
        shameMode = type
        typedText = ""
        typewriterEffect(text: message)

        // Shame scale animation
        shameScale = 0
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            shameScale = 1.0
        }

        // Red background flash
        changeMood(to: .angry, intensity: type == .bigbruh ? 1.5 : 0.8)

        // Intense shake
        let shameShakePattern: [CGFloat] = [-15, 15, -10, 10, -5, 5, 0]
        for (index, offset) in shameShakePattern.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.linear(duration: 0.05)) {
                    shakeOffset = offset
                }
            }
        }

        // Clear shame mode after 8 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            withAnimation {
                shameMode = nil
                shameScale = 0
            }
        }
    }
}

#Preview {
    CallScreen()
        .environmentObject(AppNavigator())
}
