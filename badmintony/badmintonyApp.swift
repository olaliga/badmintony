//
//  badmintonyApp.swift
//  badmintony
//
//  Created by 黃仕傑 on 2025/5/6.
//

import SwiftUI
import SwiftData

@main
struct badmintonyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Onboarding1View()
        }
        .modelContainer(sharedModelContainer)
    }
}
