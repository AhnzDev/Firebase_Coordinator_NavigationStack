//
//  AuthentivationManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import Foundation
import FirebaseAuth
import CryptoKit

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
    
    // 카카오 액세스 토큰을 Firebase 패스워드로 변환
    private func hashKakaoToken(_ token: String) -> String {
        let inputData = Data(token.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
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
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
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
        
        // ✅ 새로운 안전한 방식: 이메일 확인 후 업데이트
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
        
        // 사용자에게 안내 메시지 필요:
        // "새 이메일 주소로 확인 메일을 보냈습니다. 확인 후 이메일이 변경됩니다."
    }
    
    // 고급: 재인증 후 이메일 변경 (더 안전)
    func updateEmailWithReauth(newEmail: String, currentPassword: String) async throws {
        guard let user = Auth.auth().currentUser,
              let currentEmail = user.email else {
            throw URLError(.badServerResponse)
        }
        
        // 1. 현재 비밀번호로 재인증
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPassword)
        try await user.reauthenticate(with: credential)
        
        // 2. 재인증 성공 후 이메일 확인 메일 발송
        try await user.sendEmailVerification(beforeUpdatingEmail: newEmail)
    }
    
    // SNS 로그인 사용자용: 재인증 후 이메일 변경
    func updateEmailWithSNSReauth(newEmail: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        // SNS 사용자는 현재 프로바이더로 재인증 필요
        let providers = try getProviders()
        
        if providers.contains(.google) {
            // 구글 재인증 필요
            throw NSError(
                domain: "EmailUpdateError",
                code: 2001,
                userInfo: [
                    NSLocalizedDescriptionKey: "구글 계정으로 다시 로그인한 후 이메일을 변경해주세요."
                ]
            )
        } else if providers.contains(.apple) {
            // 애플 재인증 필요
            throw NSError(
                domain: "EmailUpdateError", 
                code: 2002,
                userInfo: [
                    NSLocalizedDescriptionKey: "애플 계정으로 다시 로그인한 후 이메일을 변경해주세요."
                ]
            )
        } else {
            // 이메일/패스워드 사용자 (카카오 포함)
            throw NSError(
                domain: "EmailUpdateError",
                code: 2003,
                userInfo: [
                    NSLocalizedDescriptionKey: "현재 비밀번호 입력이 필요합니다."
                ]
            )
        }
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
    func signInWithKaKao(tokens: KakaoSignInResultModel) async throws -> AuthDataResultModel{
        print("🔴 카카오 로그인 시작")
        
        guard let email = tokens.email else {
            print("🔴 이메일이 없음")
            throw URLError(.userAuthenticationRequired)
        }
        
        print("🔴 이메일 확인 완료: \(email)")
        
        // 카카오 액세스 토큰을 해시화하여 패스워드로 사용
        let hashedPassword = hashKakaoToken(tokens.accessToken)
        print("🔴 해시화된 패스워드 생성 완료")
        
        // 먼저 기존 사용자 로그인 시도
        do {
            print("🔴 기존 사용자 로그인 시도")
            let result = try await signInUser(email: email, password: hashedPassword)
            print("🔴 기존 사용자 로그인 성공")
            return result
        } catch let error as NSError {
            print("🔴 기존 사용자 로그인 실패 - 에러 도메인: \(error.domain), 코드: \(error.code)")
            
            // Firebase Auth 에러 처리
            if error.domain == "FIRAuthErrorDomain" {
                switch error.code {
                case 17011: // ERROR_USER_NOT_FOUND
                    print("🔴 사용자 없음 - 회원가입 시도")
                    // 사용자가 존재하지 않는 경우 - 새로 회원가입
                    do {
                        let result = try await createUser(email: email, password: hashedPassword)
                        print("🔴 신규 사용자 생성 성공")
                        return result
                    } catch let createError as NSError {
                        print("🔴 신규 사용자 생성 실패 - 에러 도메인: \(createError.domain), 코드: \(createError.code)")
                        
                        if createError.domain == "FIRAuthErrorDomain" && createError.code == 17007 {
                            // 이미 존재하는 이메일인 경우 (다른 프로바이더로 가입됨)
                            throw NSError(
                                domain: "KakaoLoginError",
                                code: 1001,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "이 이메일(\(email))은 이미 다른 방식으로 가입되어 있습니다. 해당 방식으로 로그인해주세요."
                                ]
                            )
                        }
                        throw createError
                    }
                    
                case 17009: // ERROR_WRONG_PASSWORD
                    print("🔴 패스워드 불일치 에러")
                    // 카카오 토큰이 변경되었을 수 있음
                    throw NSError(
                        domain: "KakaoLoginError", 
                        code: 1002,
                        userInfo: [
                            NSLocalizedDescriptionKey: "카카오 로그인 정보가 변경되었습니다. 앱을 재시작하고 다시 시도해주세요."
                        ]
                    )
                    
                case 17004: // ERROR_INVALID_CREDENTIAL  
                    print("🔴 잘못된 크리덴셜 에러 - 회원가입 시도")
                    // 크리덴셜 형식 문제 - 회원가입 시도
                    do {
                        let result = try await createUser(email: email, password: hashedPassword)
                        print("🔴 신규 사용자 생성 성공")
                        return result
                    } catch let createError as NSError {
                        print("🔴 신규 사용자 생성 실패 - 에러 도메인: \(createError.domain), 코드: \(createError.code)")
                        
                        if createError.domain == "FIRAuthErrorDomain" && createError.code == 17007 {
                            // 이미 존재하는 이메일인 경우
                                                         throw NSError(
                                 domain: "KakaoLoginError",
                                 code: 1001, 
                                 userInfo: [
                                     NSLocalizedDescriptionKey: "이 이메일(\(email))은 이미 다른 방식으로 가입되어 있습니다. 해당 방식으로 로그인해주세요."
                                 ]
                             )
                        }
                        throw createError
                    }
                    
                default:
                    print("🔴 알 수 없는 Firebase Auth 에러: \(error.code)")
                    throw error
                }
            }
            print("🔴 Firebase Auth 에러가 아님")
            throw error
        }
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

