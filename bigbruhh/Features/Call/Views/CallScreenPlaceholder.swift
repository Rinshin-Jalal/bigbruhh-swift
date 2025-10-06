//
//  CallScreenPlaceholder.swift
//  bigbruhh
//
//  Placeholder for call screen - to be implemented
//

import SwiftUI

struct CallScreenPlaceholder: View {
    @EnvironmentObject var navigator: AppNavigator

    var body: some View {
        ZStack {
            Color.brutalBlack
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Phone Icon
                ZStack {
                    Circle()
                        .fill(Color.brutalRed)
                        .frame(width: 120, height: 120)

                    Image(systemName: "phone.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }

                // Title
                Text("CALL SCREEN")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.white)
                    .tracking(2)

                // Description
                Text("Call screen implementation\ncoming soon")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Spacer()

                // Back Button
                Button(action: {
                    navigator.showHome()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .bold))

                        Text("BACK TO HOME")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color.brutalRed)
                    .cornerRadius(8)
                }

                Spacer()
                    .frame(height: 100)
            }
        }
    }
}

#Preview {
    CallScreenPlaceholder()
        .environmentObject(AppNavigator())
}
