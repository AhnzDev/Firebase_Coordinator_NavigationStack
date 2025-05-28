//
//  RootView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var naviPathFinder = NavigationPathFinder.shared
    
    @State var showInEmailView: Bool = false
    
    var body: some View {
        ZStack {
            if !showInEmailView {
                NavigationStack {
                    SettingsView(showSignInView: $showInEmailView)
                }
            }
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.naviPathFinder.showInEmailView = authUser == nil ? true : false
            
        }
        .fullScreenCover(isPresented:  $showInEmailView){
            NavigationStack(path: $naviPathFinder.path) {
                AuthenticationView(showSignInView: $showInEmailView)
            }
            .environmentObject(naviPathFinder)
        }
        
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationPathFinder.shared)
}
