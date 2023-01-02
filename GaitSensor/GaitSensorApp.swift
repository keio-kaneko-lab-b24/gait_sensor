//
//  GaitSensorApp.swift
//  GaitSensor
//
//  Created by Tatsuya Mizuguchi on 2023/01/02.
//

import SwiftUI

@main
struct GaitSensorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
