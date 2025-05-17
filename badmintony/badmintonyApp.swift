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

    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @State private var navigationPath = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                if hasOnboarded {
                    HomeScreenView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            switch destination {
                            case .selectShotType:
                                SelectShotTypeView(navigationPath: $navigationPath)
                            }
                        }
                } else {
                    Onboarding1View(navigationPath: $navigationPath)
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
