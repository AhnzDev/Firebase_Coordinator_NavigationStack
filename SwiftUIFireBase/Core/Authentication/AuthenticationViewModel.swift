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
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
    }
    
    func signInApple() async throws{
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    }
    
    func signInKakao() async throws {
        print("🔴 카카오 로그인 시작")
        
        do {
            print("🔴 카카오 헬퍼 토큰 요청 시작")
            let helper = SignInKakaoHelper()
            let tokens = try await helper.singIn()
            print("🔴 카카오 토큰 획득 성공 - 이메일: \(tokens.email ?? "없음"), 액세스토큰: \(tokens.accessToken.prefix(20))...")
            
            print("🔴 Firebase 카카오 로그인 시작")
            try await AuthenticationManager.shared.signInWithKaKao(tokens: tokens)
            print("🔴 Firebase 카카오 로그인 성공")
            
        } catch let error as NSError {
            print("🔴 카카오 로그인 에러 발생:")
            print("🔴 에러 도메인: \(error.domain)")
            print("🔴 에러 코드: \(error.code)")
            print("🔴 에러 메시지: \(error.localizedDescription)")
            
            // 카카오 로그인 관련 에러 처리
            if error.domain == "KakaoLoginError" {
                errorMessage = error.localizedDescription
                showError = true
                throw error
            }
            throw error
        }
    }
    
    func clearError() {
        errorMessage = ""
        showError = false
    }
}

