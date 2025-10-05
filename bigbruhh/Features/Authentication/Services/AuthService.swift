//
//  AuthService.swift
//  BigBruh
//
//  Authentication service matching nrn/contexts/AuthContext.tsx

import Foundation
import SwiftUI
import Combine
import Supabase
import Auth
import PostgREST
import AuthenticationServices

typealias SupabaseSession = Auth.Session

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var session: SupabaseSession? = nil
    @Published var user: User? = nil
    @Published var loading = true
    @Published var isAuthenticated = false

    private let supabase = SupabaseManager.shared.client

    private init() {
        Task {
            await initialize()
        }
    }

    // MARK: - Initialization
    func initialize() async {
        Config.log("Initializing AuthService", category: "Auth")

        // Get current session
        do {
            session = try await supabase.auth.session
            if let session = session {
                Config.log("Session found", category: "Auth")
                await fetchUserProfile(userId: session.user.id.uuidString)
            }
        } catch {
            Config.log("No existing session: \(error)", category: "Auth")
        }

        loading = false

        // Listen for auth state changes
        for await state in supabase.auth.authStateChanges {
            Config.log("Auth state changed: \(state.event)", category: "Auth")

            session = state.session
            if let session = state.session {
                await fetchUserProfile(userId: session.user.id.uuidString)
            } else {
                user = nil
                isAuthenticated = false
            }
        }
    }

    // MARK: - Sign In with Apple
    func signInWithApple() async throws {
        Config.log("Starting Apple Sign In", category: "Auth")

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        let delegate = AppleSignInDelegate()

        controller.delegate = delegate
        controller.presentationContextProvider = delegate

        controller.performRequests()

        // Wait for the result
        let credential = try await delegate.credential

        // Sign in with Supabase
        guard let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            throw NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid identity token"])
        }

        let session = try await supabase.auth.signInWithIdToken(
            credentials: .init(
                provider: .apple,
                idToken: idToken
            )
        )

        Config.log("Apple Sign In successful", category: "Auth")

        // Create user profile
        let fullName = credential.fullName
        let displayName = [fullName?.givenName, fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")

        await createUserProfile(
            userId: session.user.id.uuidString,
            email: session.user.email ?? "",
            name: displayName.isEmpty ? nil : displayName
        )

        await fetchUserProfile(userId: session.user.id.uuidString)
    }

    // MARK: - Sign Out
    func signOut() async throws {
        Config.log("Signing out", category: "Auth")
        loading = true

        try await supabase.auth.signOut()

        session = nil
        user = nil
        isAuthenticated = false
        loading = false

        Config.log("Sign out successful", category: "Auth")
    }

    // MARK: - User Profile Management
    private func fetchUserProfile(userId: String) async {
        do {
            let response: User = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value

            user = response
            isAuthenticated = true
            Config.log("User profile fetched", category: "Auth")

        } catch {
            Config.log("Failed to fetch user profile: \(error)", category: "Auth")
        }
    }

    private func createUserProfile(userId: String, email: String, name: String?) async {
        do {
            // Check if profile exists
            let existing: [User] = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId)
                .execute()
                .value

            if !existing.isEmpty {
                Config.log("User profile already exists", category: "Auth")
                return
            }

            // Create new profile
            let profileName = name ?? email.components(separatedBy: "@").first ?? "User"

            let _: User = try await supabase
                .from("users")
                .insert([
                    "id": userId,
                    "email": email,
                    "name": profileName
                ])
                .select()
                .single()
                .execute()
                .value

            Config.log("User profile created", category: "Auth")

        } catch {
            Config.log("Failed to create user profile: \(error)", category: "Auth")
        }
    }

    func updateProfile(name: String) async throws {
        guard let userId = user?.id else {
            throw NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        let _: User = try await supabase
            .from("users")
            .update(["name": name, "updated_at": ISO8601DateFormatter().string(from: Date())])
            .eq("id", value: userId)
            .select()
            .single()
            .execute()
            .value

        await fetchUserProfile(userId: userId)
        Config.log("Profile updated", category: "Auth")
    }
}

// MARK: - Apple Sign In Delegate
class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?

    var credential: ASAuthorizationAppleIDCredential {
        get async throws {
            try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            continuation?.resume(returning: appleIDCredential)
        } else {
            continuation?.resume(throwing: NSError(domain: "AppleSignIn", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid credential"]))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
