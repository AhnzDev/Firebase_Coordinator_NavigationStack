//
//  AuthentivationManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    // google.com
    // password
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                print("Not Found Provider ID: \(provider.providerID)")
                assertionFailure() // 인증된 로그인 방법만 사용하기 위해
            }
        }
        return providers
    }
    
}
//MARK: SIGN IN EMAIL
/// 카카오 로그인 시 이메일과 토큰으로 로그인함
extension AuthenticationManager {
    @discardableResult
    func createUser(email: String, password: String) async throws ->AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
//        try await user.sendEmailVerification(beforeUpdatingEmail: email) // 확인 이메일 전송
        try await user.updateEmail(to: email)
//        try await user.updateEmail(to: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
}

//MARK: SIGN IN SSO
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return  try await signIn(credential: credential)
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel{
        // Initialize a Firebase credential, including the user's full name.
        
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)
    // Sign in with Firebase.
        return  try await signIn(credential: credential)
    }
    
    @discardableResult
    func signInWithKaKao(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel{
        // Initialize a Firebase credential, including the user's full name.
        
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)
    // Sign in with Firebase.
        return  try await signIn(credential: credential)
    }
    
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

