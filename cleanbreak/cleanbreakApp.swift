//
//  cleanbreakApp.swift
//  cleanbreak
//
//  Created by user270007 on 2/9/25.
//

import SwiftUI

@main
struct cleanbreakApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TrackerView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
