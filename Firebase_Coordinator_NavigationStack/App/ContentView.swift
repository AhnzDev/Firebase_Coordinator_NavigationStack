//
//  ContentView.swift
//  Firebase_Coordinator_NavigationStack
//
//  Created by Jihoon on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var navPathFinder: NavigationFinder
    @State private var currentTab: Tab = .home
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ZStack(alignment: .bottom) {
                VStack {
                    AuthenticationView()
                    Spacer()
                    CustomTabBar(currentTab: $currentTab)
                }
            }
        }.navigationDestination(for: ViewOption.self) { option in
            option.view()
        }
        
    }
}

struct FirstDestinationView: View {
    var body: some View {
        Text("목적지가 되는 뷰")
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationFinder.shared)
}
