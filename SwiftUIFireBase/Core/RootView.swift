//
//  RootView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var naviPathFinder = NavigationPathFinder.shared
    
    @State var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProductView()
//                    ProfileView(showSignInView: $showSignInView)
//                    SettingsView(showSignInView: $showSignInView)
                }
            }
        }
        .padding()
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.naviPathFinder.showInEmailView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented:  $showSignInView){
            NavigationStack(path: $naviPathFinder.path) {
                AuthenticationView(showSignInView: $showSignInView)
            }
            .environmentObject(naviPathFinder)
        }
        
        
    }
}



#Preview {
    RootView()
        .environmentObject(NavigationPathFinder.shared)
}
