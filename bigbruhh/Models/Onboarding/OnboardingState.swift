//
//  OnboardingState.swift
//  bigbruhh
//
//  Manages the overall state of the 45-step onboarding process
//  Migrated from: nrn/types/onboarding.ts - OnboardingState interface
//

import Foundation
import Combine

// MARK: - Onboarding State

class OnboardingState: ObservableObject, Codable {
    @Published var currentStep: Int                      // 1-45 BigBruh steps
    @Published var responses: [Int: UserResponse]        // Step ID -> Response
    @Published var brotherName: String                   // User's chosen "brother" name
    @Published var userName: String?                     // User's real name
    @Published var isCompleted: Bool
    @Published var startedAt: Date
    @Published var completedAt: Date?

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case currentStep
        case responses
        case brotherName
        case userName
        case isCompleted
        case startedAt
        case completedAt
    }

    // MARK: - Initialization

    init(
        currentStep: Int = 1,
        responses: [Int: UserResponse] = [:],
        brotherName: String = "",
        userName: String? = nil,
        isCompleted: Bool = false,
        startedAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.currentStep = currentStep
        self.responses = responses
        self.brotherName = brotherName
        self.userName = userName
        self.isCompleted = isCompleted
        self.startedAt = startedAt
        self.completedAt = completedAt
    }

    // MARK: - Codable

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentStep = try container.decode(Int.self, forKey: .currentStep)
        responses = try container.decode([Int: UserResponse].self, forKey: .responses)
        brotherName = try container.decode(String.self, forKey: .brotherName)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        startedAt = try container.decode(Date.self, forKey: .startedAt)
        completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentStep, forKey: .currentStep)
        try container.encode(responses, forKey: .responses)
        try container.encode(brotherName, forKey: .brotherName)
        try container.encodeIfPresent(userName, forKey: .userName)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(startedAt, forKey: .startedAt)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
    }

    // MARK: - State Management

    func saveResponse(_ response: UserResponse) {
        responses[response.stepId] = response
    }

    func getResponse(for stepId: Int) -> UserResponse? {
        return responses[stepId]
    }

    func nextStep() {
        currentStep += 1
    }

    func previousStep() {
        guard currentStep > 1 else { return }
        currentStep -= 1
    }

    func complete() {
        isCompleted = true
        completedAt = Date()
    }

    func reset() {
        currentStep = 1
        responses = [:]
        brotherName = ""
        userName = nil
        isCompleted = false
        startedAt = Date()
        completedAt = nil
    }

    // MARK: - Progress Tracking

    var progressPercentage: Double {
        let totalSteps = 45.0
        return (Double(currentStep) / totalSteps) * 100.0
    }

    var totalResponses: Int {
        return responses.count
    }

    var hasStarted: Bool {
        return currentStep > 1 || !responses.isEmpty
    }
}
