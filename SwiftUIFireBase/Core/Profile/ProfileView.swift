//
//  ProfileView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/2/25.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    
    func loadCurrentUser() throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
}

struct ProfileView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.uid)")
            }
        }
        .onAppear {
            Task {
                try? viewModel.loadCurrentUser()
            }
        }
        .navigationTitle(Text("Profile"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
                
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSignInView: .constant(false))
    }
}
