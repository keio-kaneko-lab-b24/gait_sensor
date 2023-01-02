//
//  GaitSensorApp.swift
//  GaitSensor
//
//  Created by Tatsuya Mizuguchi on 2023/01/02.
//

import SwiftUI

@main
struct GaitSensorApp: App {
    let persistentController = PersistentController()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentController.container.viewContext)
        }
    }
}
