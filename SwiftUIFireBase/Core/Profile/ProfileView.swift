//
//  ProfileView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/2/25.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResultModel = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResultModel.uid)
        debugPrint(#fileID,#function,"ahnz - \(user)")
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        
//        user.togglePremiumStatus()
//        let currentValue = user.isPremium ?? false
//        user.isPremium = !currentValue
//        let updatedUser = user.togglePremiumStatus()
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
//            try await UserManager.shared.updateUserPremiumStatus(user: user)
            self.user = try await UserManager.shared.getUser(userID: user.userId)
        }
        
    }
}

struct ProfileView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(String(describing: user.userId))")
                
                Button {
                    self.viewModel.togglePremiumStatus()
                }label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
            }
           
        }
        .onAppear {
            Task {
                
                try? await viewModel.loadCurrentUser()
                
                // 로그인 안 되어 있으면 띄우기
                if viewModel.user == nil {
                    showSignInView = true
                }
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
