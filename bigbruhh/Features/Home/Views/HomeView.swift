//
//  HomeView.swift
//  bigbruhh
//
//  Main home screen for authenticated users
//

import SwiftUI

struct HomeView: View {
    @StateObject private var authService = AuthService.shared

    var body: some View {
        ZStack {
            Color.brutalBlack.ignoresSafeArea()

            VStack(spacing: Spacing.xl) {
                Text("HOME")
                    .font(.headline)
                    .foregroundColor(.neonGreen)
                    .brutalStyle()

                if let user = authService.user {
                    Text("Welcome, \(user.displayName)")
                        .font(.bodyBold)
                        .foregroundColor(.white)

                    Text(user.email ?? "No email")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer().frame(height: 40)

                Button {
                    Task {
                        try? await authService.signOut()
                    }
                } label: {
                    Text("SIGN OUT")
                        .font(.buttonMedium)
                        .foregroundColor(.brutalBlack)
                        .frame(maxWidth: .infinity)
                        .frame(height: Spacing.buttonHeightMedium)
                        .background(Color.brutalRed)
                        .cornerRadius(Spacing.radiusMedium)
                }
                .padding(.horizontal, Spacing.xxl)
            }
            .padding(.top, 60)
        }
    }
}
