//
//  EvidenceView.swift
//  bigbruhh
//
//  EVIDENCE tab - Call history with brutal reviews matching NRN history.tsx
//

import SwiftUI

struct CallHistoryItem: Identifiable {
    let id: String
    let date: String
    let time: String
    let duration: Int
    let promisesAnalyzed: Int
    let promisesBroken: Int
    let promisesKept: Int
    let worstExcuse: String?
    let brutalReview: BrutalReview?

    struct BrutalReview {
        let paragraph: String
        let impactScore: Int
        let dominantEmotion: String
        let patternIdentified: String?
    }
}

struct EvidenceView: View {
    @State private var callHistory: [CallHistoryItem] = []
    @State private var loading: Bool = false

    var body: some View {
        ZStack {
            Color.brutalBlack
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header with logo
                    HeaderLogoBar()

                    // HERO EVIDENCE CARD - matches NRN
                    heroEvidenceCard

                    // Assessment Card
                    Text("EVIDENCE ASSESSMENT")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(white: 0.7, opacity: 1.0))
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 8)

                    assessmentCard

                    // Stats Grid
                    Text("EVIDENCE STATS")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(white: 0.7, opacity: 1.0))
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 8)

                    statsGrid

                    // Recent Evidence
                    Text("RECENT EVIDENCE")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(white: 0.7, opacity: 1.0))
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 8)

                    recentEvidenceList

                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            loadCallHistory()
        }
    }

    // MARK: - Hero Evidence Card

    private var heroEvidenceCard: some View {
        VStack(spacing: 10) {
            Text("pattern detected")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(white: 0.85, opacity: 1.0))

            Text(dominantPattern)
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.white)
                .tracking(2)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 250)
        .background(Color.black)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    // MARK: - Assessment Card

    private var assessmentCard: some View {
        VStack {
            Text(evidenceAssessment)
                .font(.system(size: 35, weight: .black))
                .foregroundColor(.white)
                .tracking(4)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 100)
        .background(Color(hex: "#B22222"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#dd2a2a"), lineWidth: 2)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                statCard(
                    value: "\(callHistory.count)",
                    label: "CALLS",
                    backgroundColor: Color(hex: "#C8E6C9"),
                    borderColor: Color(hex: "#88a88a"),
                    textColor: .black
                )

                statCard(
                    value: "\(totalBroken)",
                    label: "BROKEN",
                    backgroundColor: Color(hex: "#DC143C"),
                    borderColor: Color(hex: "#8B0000"),
                    textColor: .white
                )
            }

            HStack(spacing: 8) {
                statCard(
                    value: "\(patternsIdentified)",
                    label: "PATTERNS",
                    backgroundColor: Color(hex: "#FFD700"),
                    borderColor: Color(hex: "#B8860B"),
                    textColor: .black
                )

                statCard(
                    value: "\(successRate)%",
                    label: "SUCCESS",
                    backgroundColor: Color(hex: "#8B00FF"),
                    borderColor: Color(hex: "#4B0082"),
                    textColor: .white
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }

    private func statCard(value: String, label: String, backgroundColor: Color, borderColor: Color, textColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.system(size: 48, weight: .black))
                .foregroundColor(textColor)
                .tracking(2)

            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(textColor.opacity(0.8))
                .tracking(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 130)
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 3)
        )
    }

    // MARK: - Recent Evidence List

    private var recentEvidenceList: some View {
        VStack(spacing: 12) {
            ForEach(callHistory.prefix(3)) { call in
                evidenceCard(call: call)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 100)
    }

    private func evidenceCard(call: CallHistoryItem) -> some View {
        let isFail = call.promisesBroken > 0
        let bgColor = isFail ? Color(hex: "#DC143C") : Color(hex: "#C8E6C9")
        let borderColor = isFail ? Color(hex: "#8B0000") : Color(hex: "#88a88a")
        let textColor = isFail ? Color.white : Color.black

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formatDateShort(call.date))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(textColor)
                    .tracking(1)

                Spacer()

                Text(isFail ? "FAIL" : "PASS")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(textColor)
                    .tracking(2)
            }

            if let review = call.brutalReview {
                Text(review.paragraph)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(textColor)
                    .lineSpacing(4)
                    .lineLimit(2)
            } else if let excuse = call.worstExcuse {
                Text("\"\(excuse)\"")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(textColor)
                    .lineSpacing(4)
                    .lineLimit(2)
                    .italic()
            } else {
                Text("Evidence analyzed")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(textColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 3)
        )
    }

    // MARK: - Computed Properties

    private var dominantPattern: String {
        if callHistory.isEmpty { return "NO EVIDENCE" }

        let patterns = callHistory.compactMap { $0.brutalReview?.patternIdentified }
        return patterns.first ?? "ANALYZING PATTERNS"
    }

    private var evidenceAssessment: String {
        if callHistory.isEmpty { return "PATHETIC" }

        let rate = successRate
        if rate >= 80 { return "RELIABLE EVIDENCE" }
        if rate >= 60 { return "MIXED EVIDENCE" }
        if rate >= 40 { return "FAILURE EVIDENCE" }
        if rate >= 20 { return "DAMNING EVIDENCE" }
        return "HOPELESS CASE"
    }

    private var totalBroken: Int {
        callHistory.reduce(0) { $0 + $1.promisesBroken }
    }

    private var totalKept: Int {
        callHistory.reduce(0) { $0 + $1.promisesKept }
    }

    private var totalPromises: Int {
        callHistory.reduce(0) { $0 + $1.promisesAnalyzed }
    }

    private var successRate: Int {
        guard totalPromises > 0 else { return 0 }
        return Int((Double(totalKept) / Double(totalPromises)) * 100)
    }

    private var patternsIdentified: Int {
        callHistory.filter { $0.brutalReview?.patternIdentified != nil }.count
    }

    private func formatDateShort(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "TODAY"
        } else if calendar.isDateInYesterday(date) {
            return "YESTERDAY"
        } else {
            let shortFormatter = DateFormatter()
            shortFormatter.dateFormat = "MMM d"
            return shortFormatter.string(from: date).uppercased()
        }
    }

    // MARK: - Data Loading

    private func loadCallHistory() {
        // TODO: Load from API
        // Mock data matching NRN test data
        callHistory = [
            CallHistoryItem(
                id: "1",
                date: ISO8601DateFormatter().string(from: Date()).prefix(10).description,
                time: "08:30",
                duration: 7,
                promisesAnalyzed: 5,
                promisesBroken: 4,
                promisesKept: 1,
                worstExcuse: "I was too tired and stressed from work",
                brutalReview: CallHistoryItem.BrutalReview(
                    paragraph: "Another pathetic display of weakness. You made 5 promises and broke 4 of them like the unreliable person you've always been.",
                    impactScore: 8,
                    dominantEmotion: "DISAPPOINTMENT",
                    patternIdentified: "CHRONIC EXCUSE-MAKER"
                )
            ),
            CallHistoryItem(
                id: "2",
                date: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-86400)).prefix(10).description,
                time: "20:15",
                duration: 6,
                promisesAnalyzed: 3,
                promisesBroken: 2,
                promisesKept: 1,
                worstExcuse: "Netflix had a new season of my show",
                brutalReview: CallHistoryItem.BrutalReview(
                    paragraph: "You chose entertainment over your commitments. Again. This is why you're stuck in the same place while others move forward.",
                    impactScore: 7,
                    dominantEmotion: "SHAME",
                    patternIdentified: "INSTANT GRATIFICATION SEEKER"
                )
            ),
            CallHistoryItem(
                id: "3",
                date: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-2 * 86400)).prefix(10).description,
                time: "07:45",
                duration: 5,
                promisesAnalyzed: 4,
                promisesBroken: 4,
                promisesKept: 0,
                worstExcuse: "My phone battery died and I forgot",
                brutalReview: CallHistoryItem.BrutalReview(
                    paragraph: "Zero promises kept. ZERO. This is rock bottom performance. You're not even trying anymore.",
                    impactScore: 9,
                    dominantEmotion: "DISGUST",
                    patternIdentified: "SERIAL PROMISE-BREAKER"
                )
            )
        ]
    }
}

#Preview {
    EvidenceView()
}
