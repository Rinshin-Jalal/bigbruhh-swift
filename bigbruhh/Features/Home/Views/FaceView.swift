//
//  FaceView.swift
//  bigbruhh
//
//  FACE tab - Main dashboard with countdown timer and stats
//

import SwiftUI
import Combine

struct FaceView: View {
    @State private var timeRemaining: TimeInterval = 2 * 60 * 60 // 2 hours default
    @State private var timerPulse: CGFloat = 1.0
    @State private var showRedFlash: Bool = false
    @State private var currentDate: String = ""

    // User stats
    @State private var promisesMade: Int = 12
    @State private var promisesBroken: Int = 8
    @State private var streakDays: Int = 3
    @State private var trustPercentage: Int = 45

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Computed Properties for Grades

    private var successRate: Int {
        guard promisesMade > 0 else { return 0 }
        let kept = promisesMade - promisesBroken
        return Int((Double(kept) / Double(promisesMade)) * 100)
    }

    private var progressMessage: String {
        if successRate >= 80 { return "Actually locked in 🔥" }
        if successRate >= 60 { return "Getting there... maybe" }
        if successRate >= 40 { return "Still making excuses bro" }
        if successRate >= 20 { return "You're not even trying" }
        return "Absolutely cooked 💀"
    }

    private var promiseGrade: (grade: String, message: String) {
        if successRate >= 90 { return ("A+", "Actually reliable") }
        if successRate >= 80 { return ("A", "Pretty good") }
        if successRate >= 70 { return ("B+", "Not bad") }
        if successRate >= 60 { return ("B", "Mediocre") }
        if successRate >= 50 { return ("C", "Weak effort") }
        if successRate >= 40 { return ("D", "Disappointing") }
        return ("F", "Pathetic")
    }

    private var excuseGrade: (grade: String, message: String) {
        // Inverse grading - more excuses = higher grade
        if successRate <= 20 { return ("A+", "Too creative") }
        if successRate <= 40 { return ("A", "Very creative") }
        if successRate <= 60 { return ("B", "Getting there") }
        if successRate <= 80 { return ("C", "Boring excuses") }
        return ("F", "No excuses!")
    }

    private var streakGrade: (grade: String, message: String) {
        if streakDays >= 14 { return ("A+", "On fire") }
        if streakDays >= 7 { return ("B+", "Building up") }
        if streakDays >= 3 { return ("C", "Inconsistent") }
        if streakDays >= 1 { return ("D", "Broken") }
        return ("F", "Non-existent")
    }

    private var overallGrade: (grade: String, message: String) {
        if successRate >= 90 { return ("A+", "Exceptional") }
        if successRate >= 80 { return ("A", "Good work") }
        if successRate >= 70 { return ("B", "Average") }
        if successRate >= 60 { return ("C", "Below par") }
        if successRate >= 50 { return ("D", "Disappointing") }
        return ("F", "Hopeless")
    }

    private func gradeColor(_ grade: String) -> Color {
        if grade.contains("A") { return Color(hex: "#00FF00") } // Green for A
        if grade.contains("B") { return Color(hex: "#FFD700") } // Gold for B
        if grade.contains("C") { return Color(hex: "#FF8C00") } // Orange for C
        if grade.contains("D") { return Color(hex: "#8B00FF") } // Purple for D
        return Color(hex: "#DC143C") // Red for F
    }

    var body: some View {
        ZStack {
            Color.brutalBlack
                .ignoresSafeArea()

            // Red flash overlay
            if showRedFlash {
                Color.red.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            ScrollView {
                VStack(spacing: 0) {
                    // Header with logo
                    HeaderLogoBar()

                    // Main countdown card
                    countdownCard

                    // Notification style card
                    notificationCard

                    // Progress bar
                    progressBar

                    // Grade cards grid
                    gradeCardsGrid

                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            updateCurrentDate()
            loadUserStatus()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
    }

    // MARK: - Hero Call Timer (Main Element)

    private var countdownCard: some View {
        VStack(spacing: 20) {
            Text("next call in")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.white.opacity(0.87))
                .tracking(1)

            // HERO TIMER - BIG DISPLAY
            Text(timeRemainingString)
                .font(.system(size: 64, weight: .black))
                .foregroundColor(.white)
                .tracking(4)
                .monospacedDigit()
                .scaleEffect(timerPulse)
                .animation(.easeInOut(duration: isUnderOneHour ? 0.5 : 1.0), value: timerPulse)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 250)
    }

    private var timeRemainingString: String {
        String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // MARK: - Notification Card

    private var notificationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.brutalRed)
                            .frame(width: 24, height: 24)

                        Text("🔥")
                            .font(.system(size: 12))
                    }

                    Text("BigBruh")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                Text("now")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.5))
            }

            Text("ACCOUNTABILITY CHECK")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .tracking(1)

            Text("No excuses today. Your call is coming.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.white.opacity(0.8))
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color(white: 0.1, opacity: 1.0))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(white: 0.2, opacity: 1.0), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DISCIPLINE LEVEL")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color.white.opacity(0.5))
                .tracking(2)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("DISCIPLINE LEVEL")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(successRate)%")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                }

                // Progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(white: 0.2, opacity: 1.0))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(successRate >= 60 ? Color.neonGreen : Color.brutalRed)
                        .frame(width: max(0, CGFloat(successRate) / 100.0 * UIScreen.main.bounds.width * 0.85), height: 8)
                }

                Text(progressMessage)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.6))
                    .italic()
            }
            .padding(16)
            .background(Color(white: 0.05, opacity: 1.0))
            .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    // MARK: - Grade Cards Grid

    private var gradeCardsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PERFORMANCE GRADES")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color.white.opacity(0.5))
                .tracking(2)

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    gradeCard(category: "PROMISES", grade: promiseGrade.grade, message: promiseGrade.message, color: gradeColor(promiseGrade.grade))
                    gradeCard(category: "EXCUSES", grade: excuseGrade.grade, message: excuseGrade.message, color: gradeColor(excuseGrade.grade))
                }

                HStack(spacing: 12) {
                    gradeCard(category: "STREAK", grade: streakGrade.grade, message: streakGrade.message, color: gradeColor(streakGrade.grade))
                    gradeCard(category: "OVERALL", grade: overallGrade.grade, message: overallGrade.message, color: gradeColor(overallGrade.grade))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func gradeCard(category: String, grade: String, message: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(category)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
                .tracking(1)

            Text(grade)
                .font(.system(size: 48, weight: .black))
                .foregroundColor(.white)

            Text(message)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(color)
        .cornerRadius(12)
    }

    // MARK: - Timer Logic

    private var hours: Int {
        Int(timeRemaining) / 3600
    }

    private var minutes: Int {
        (Int(timeRemaining) % 3600) / 60
    }

    private var seconds: Int {
        Int(timeRemaining) % 60
    }

    private var isUnderOneHour: Bool {
        timeRemaining < 3600 && timeRemaining > 0
    }

    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1

            // Pulse animation
            withAnimation {
                timerPulse = timerPulse == 1.0 ? 0.98 : 1.0
            }

            // Red flash on exact hour marks
            if seconds == 0 && minutes == 0 {
                triggerRedFlash()
            }
        }
    }

    private func triggerRedFlash() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showRedFlash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showRedFlash = false
            }
        }
    }

    private func updateCurrentDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        currentDate = formatter.string(from: Date())
    }

    private func loadUserStatus() {
        // TODO: Load from API
        // Mock data already set in @State
    }
}

#Preview {
    FaceView()
}
