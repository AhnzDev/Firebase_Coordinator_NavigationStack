//
//  AuthenticationView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 4/30/25.
//

import SwiftUI

struct AuthenticationView: View {
    let appleProducts: [String] = ["Mac", "Macbook", "iPhone", "iPad"]
    @Binding var showSignInView: Bool
    @EnvironmentObject private var naviPathFinder: NavigationPathFinder
    
    
    var body: some View {
        NavigationStack(path: $naviPathFinder.path){
            VStack {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .onTapGesture {
                        naviPathFinder.path.append("ddd")
                    }
            }
            .padding()
            .navigationTitle("Sing In")
            .navigationDestination(for: ViewOption.self) { option in
                option.view()
            }
            .navigationDestination(for: String.self) { String in
                SignInEmailView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
        .environmentObject(NavigationPathFinder.shared)
    
}
