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
    
    func addUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.addUserPreferences(userId:  user.userId, preference: text)
//            try await UserManager.shared.updateUserPremiumStatus(user: user)
            self.user = try await UserManager.shared.getUser(userID: user.userId)
        }
    }
    
    func removeUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.removeUserPreferences(userId:  user.userId, preference: text)
//            try await UserManager.shared.updateUserPremiumStatus(user: user)
            self.user = try await UserManager.shared.getUser(userID: user.userId)
        }
    }
    
    
    func addFavoriteMovies(text: String) {
        guard let user else { return }
        let movies = Movies(id: "1", title: "Avatar 3", isPopular: true)
        Task {
            try await UserManager.shared.addUserFavoriteMovie(userId: user.userId, movies: movies)
//            try await UserManager.shared.updateUserPremiumStatus(user: user)
            self.user = try await UserManager.shared.getUser(userID: user.userId)
        }
    }
    
    func removeFavoriteMovies() {
        guard let user else { return }
        let movies = Movies(id: "1", title: "Avatar 3", isPopular: true)
        Task {
            try await UserManager.shared.removeUserFavoriteMovie(userId: user.userId)
//            try await UserManager.shared.updateUserPremiumStatus(user: user)
            self.user = try await UserManager.shared.getUser(userID: user.userId)
        }
    }
}

struct ProfileView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    
    let preferenceOption: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(String(describing: user.userId))")
                
                Button {
                    self.viewModel.togglePremiumStatus()
                }label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                HStack {
                    ForEach(preferenceOption, id: \.self) { string in
                        Button(string) {
                            if preferenceIsSelected(text: string) {
                                viewModel.removeUserPreference(text: string)
                            } else {
                                viewModel.addUserPreference(text: string)
                            }
                        }
                        .font(.headline)
                        .buttonStyle(.borderedProminent)
                        .tint( preferenceIsSelected(text: string) ? .green : .red)
                    }
                    
                    
                }
                
                Text("User preferences: \((user.preferences ?? []).joined(separator: ","))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    if user.favoriteMovies == nil {
                        viewModel.addFavoriteMovies(text: "Avartar")
                    } else {
                        viewModel.removeFavoriteMovies()
                    }
                } label: {
                    Text("Favorite Movies: \(user.favoriteMovies?.title ?? "")")
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
//    NavigationStack{
//        ProfileView(showSignInView: .constant(false))
//    }
    RootView()
}
