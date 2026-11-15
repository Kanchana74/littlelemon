//
//  LittlelemonApp.swift
//  Littlelemon
//
//  Created by Kanchana Panditha on 12/11/2026.
//

import SwiftUI
import CoreData

@main
struct LittlelemonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
