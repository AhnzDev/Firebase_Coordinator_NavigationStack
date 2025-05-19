//
//  RootView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var naviPathFinder = NavigationPathFinder.shared
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear() {
            let authUser = try? AuthentivationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack(path: $naviPathFinder.path) {
                AuthenticationView()
            }
            .environmentObject(naviPathFinder)
        }
        
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationPathFinder.shared)
}
