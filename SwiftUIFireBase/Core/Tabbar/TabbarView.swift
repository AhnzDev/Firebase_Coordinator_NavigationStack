//
//  TabbarView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/22/25.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                ProductView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }

            NavigationStack {
                Color.red
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Products")
            }

            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
