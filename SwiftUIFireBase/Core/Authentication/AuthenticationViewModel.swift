//
//  AuthenticationViewModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/1/25.
//
import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let auth = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: auth)
    }
    
    func signInApple() async throws{
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let auth = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: auth)
    }
    
    func signInKakao() async throws {
        let helper = SignInKakaoHelper()
        let tokens = try await helper.singIn()
        let auth = try await AuthenticationManager.shared.signInWithKaKao(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: auth)
    }
    
    func clearError() {
        errorMessage = ""
        showError = false
    }
}

