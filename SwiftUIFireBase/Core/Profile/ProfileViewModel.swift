//
//  ProfileViewModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/28/25.
//

import SwiftUI
import PhotosUI

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
    
    func saveProfileImage(item: PhotosPickerItem) {
        guard let user else { return }
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path,name) = try await StorageManager.shared.saveImage(data: data,userId: user.userId)
            print("SUCESS")
            print(path)
            print(name)
            try await UserManager.shared.updateUserProfileImage(userId: user.userId, path: name)
        }
    }
}
