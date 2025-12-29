//
//  ProfileView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/2/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
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
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a Photo")
                }
                
                if let urlString = user.profileImagePathUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                if user.profileImagePath != nil{
                    Button("Delete Image") {
                        viewModel.deleteProfileImage()
                    }
                }
            }
        }
        .task {
                
                try? await viewModel.loadCurrentUser()
                if let user = viewModel.user, let path = user.profileImagePath {
                    do {
                        url = try await StorageManager.shared.getUrlForImage(path: path)
                       
                    } catch {
                        print(error)
                    }
                }
                // 로그인 안 되어 있으면 띄우기
//                if viewModel.user == nil {
//                    showSignInView = true
//                }
            
        }
        .onChange(of: selectedItem, perform: { newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
            }
        })
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
