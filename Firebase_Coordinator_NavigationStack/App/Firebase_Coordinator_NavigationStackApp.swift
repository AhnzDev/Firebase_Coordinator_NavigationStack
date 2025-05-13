//
//  Firebase_Coordinator_NavigationStackApp.swift
//  Firebase_Coordinator_NavigationStack
//
//  Created by Jihoon on 4/2/25.
//

import SwiftUI

@main
struct Firebase_Coordinator_NavigationStackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationFinder.shared)
        }
    }
}
