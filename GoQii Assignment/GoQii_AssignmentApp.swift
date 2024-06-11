//
//  GoQii_AssignmentApp.swift
//  GoQii Assignment
//
//  Created by Ameya Chorghade on 11/06/24.
//

import SwiftUI

@main
struct GoQii_AssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
