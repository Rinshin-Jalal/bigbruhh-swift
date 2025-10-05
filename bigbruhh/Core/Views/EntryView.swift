//
//  EntryView.swift
//  bigbruhh
//
//  Main entry point view handling authentication flow
//

import SwiftUI

struct EntryView: View {
    @StateObject private var authService = AuthService.shared

    var body: some View {
        Group {
            if authService.loading {
                LoadingView()
            } else if authService.isAuthenticated {
                if authService.user?.onboardingCompleted == true {
                    if authService.user?.almostThereCompleted == true {
                        HomeView()
                    } else {
                        AlmostThereView()
                    }
                } else {
                    OnboardingView()
                }
            } else {
                WelcomeView()
            }
        }
    }
}
