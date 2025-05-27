//
//  SettingsView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func logOut() throws {
        try AuthentivationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthentivationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthentivationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "TestTest123@gmail.com"
        try await AuthentivationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Hello123!"
        try await AuthentivationManager.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log Out")
            }
            
            emailSection
        
            
            .navigationTitle("Settings")

        }
        
    }
}

extension SettingsView{
    
    private var emailSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Reset Password")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update Password")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update Email")
            }
        } header: {
            Text ("Email Function")
        }
        

    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: Binding.constant(false))
    }
}
