//
//  SettingsViewModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/2/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var showEmailUpdateAlert: Bool = false
    @Published var showPasswordPrompt: Bool = false
    @Published var newEmail: String = ""
    @Published var currentPassword: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func requestEmailUpdate() {
        showEmailUpdateAlert = true
    }
    
    func updateEmail() async throws {
        guard !newEmail.isEmpty else {
            alertMessage = "새 이메일 주소를 입력해주세요."
            showAlert = true
            return
        }
        
        if authProviders.contains(.email) {
            showPasswordPrompt = true
        } else {
            try await AuthenticationManager.shared.updateEmailWithSNSReauth(newEmail: newEmail)
        }
    }
    
    func updateEmailWithPassword() async throws {
        guard !currentPassword.isEmpty else {
            alertMessage = "현재 비밀번호를 입력해주세요."
            showAlert = true
            return
        }
        
        do {
            try await AuthenticationManager.shared.updateEmailWithReauth(
                newEmail: newEmail,
                currentPassword: currentPassword
            )
            
            alertMessage = "새 이메일 주소(\(newEmail))로 확인 메일을 보냈습니다. 확인 후 이메일이 변경됩니다."
            showAlert = true
            
            newEmail = ""
            currentPassword = ""
            showPasswordPrompt = false
            
        } catch {
            alertMessage = "이메일 변경 실패: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func updatePassword() async throws {
        let password = "Hello123!"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func clearAlerts() {
        showEmailUpdateAlert = false
        showPasswordPrompt = false
        showAlert = false
        newEmail = ""
        currentPassword = ""
        alertMessage = ""
    }
}
