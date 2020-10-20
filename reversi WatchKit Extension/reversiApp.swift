//
//  reversiApp.swift
//  reversi WatchKit Extension
//
//  Created by Jakob & Niko Neufeld on 20.10.20.
//

import SwiftUI

@main
struct reversiApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
