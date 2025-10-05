//
//  User.swift
//  BigBruh
//
//  User model matching Supabase auth.users schema

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String?
    let name: String?
    let createdAt: Date?
    let updatedAt: Date?
    let revenuecatCustomerId: String?
    let onboardingCompleted: Bool?
    let almostThereCompleted: Bool?
    let callStreak: Int?
    let currentGrade: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case revenuecatCustomerId = "revenuecat_customer_id"
        case onboardingCompleted = "onboarding_completed"
        case almostThereCompleted = "almost_there_completed"
        case callStreak = "call_streak"
        case currentGrade = "current_grade"
    }

    var displayName: String {
        name ?? email?.components(separatedBy: "@").first ?? "User"
    }

    var grade: Grade {
        Grade(rawValue: currentGrade ?? "F") ?? .f
    }
}

// MARK: - Grade Enum
enum Grade: String, Codable, CaseIterable {
    case a = "A"
    case b = "B"
    case c = "C"
    case f = "F"

    var color: Color {
        switch self {
        case .a: return .gradeA
        case .b: return .gradeB
        case .c: return .gradeC
        case .f: return .gradeF
        }
    }

    var emoji: String {
        switch self {
        case .a: return "🔥"
        case .b: return "💪"
        case .c: return "⚠️"
        case .f: return "💀"
        }
    }

    var message: String {
        switch self {
        case .a: return "UNSTOPPABLE"
        case .b: return "SOLID PROGRESS"
        case .c: return "BARELY PASSING"
        case .f: return "COMPLETE FAILURE"
        }
    }
}

// MARK: - User Status for Home Screen
struct UserStatus: Codable {
    let streak: Int
    let grade: Grade
    let nextCallTime: Date?
    let lastCallCompleted: Date?
    let hasActiveSubscription: Bool

    var isCallDue: Bool {
        guard let nextCall = nextCallTime else { return false }
        return Date() >= nextCall
    }

    var timeUntilNextCall: TimeInterval? {
        guard let nextCall = nextCallTime else { return nil }
        return nextCall.timeIntervalSince(Date())
    }
}

import SwiftUI
