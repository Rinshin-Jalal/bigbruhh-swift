//
//  bigbruhhApp.swift
//  bigbruhh
//
//  Created by Rinshin on 01/10/25.
//

import SwiftUI

@main
struct bigbruhhApp: App {
    init() {
        Config.log("🔥 BigBruh launching...", category: "App")
        Config.log("Supabase URL: \(Config.supabaseURL)", category: "Config")
        Config.log("RevenueCat Key: \(String(Config.revenueCatAPIKey.prefix(20)))...", category: "Config")
    }

    var body: some Scene {
        WindowGroup {
            EntryView()
        }
    }
}
