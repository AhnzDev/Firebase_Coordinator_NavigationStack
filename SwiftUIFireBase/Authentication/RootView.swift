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
                    SettingsView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.naviPathFinder.showInEmailView = authUser == nil ? true : false
           
            AZLogger.azOsLog("앱이 실행 됐습니다",level: .request)
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
