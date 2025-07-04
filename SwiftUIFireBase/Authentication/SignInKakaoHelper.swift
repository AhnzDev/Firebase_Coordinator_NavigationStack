//
//  SignInKakaoHelper.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 6/5/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

// 카카오는 이메일아이디로 가입 진행
struct KakaoSignInResultModel {
    let idToken: String // 비밀번호가 될 키
    let accessToken: String
    let name: String?
    let email: String? // 아이디로 사용
}

//@MainActor
final class SignInKakaoHelper: NSObject {
    @MainActor
    func singIn() async throws -> KakaoSignInResultModel {
        // 카카오톡 실행 가능 여부 확인
        let oauthToken: OAuthToken = try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { token, error in
                    if let token = token {
                        continuation.resume(returning: token)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(
                            throwing: NSError(domain: "KakaoLogin", code: -1, userInfo: [NSLocalizedDescriptionKey: "loginWithKakaoTalk: token and error are both nil"])
                        )
                    }
                }
            } else {
                // 시뮬레이터 포함: 기본 계정 로그인 시도
                UserApi.shared.loginWithKakaoAccount { token, error in
                    if let token = token {
                        continuation.resume(returning: token)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(
                            throwing: NSError(domain: "KakaoLogin", code: -1, userInfo: [NSLocalizedDescriptionKey: "loginWithKakaoAccount: token and error are both nil"])
                        )
                    }
                }
            }
        }
        
        let user: User = try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                }
            }
        }
        
        guard let account = user.kakaoAccount,
              let email = account.email else {
            throw URLError(.userAuthenticationRequired)
        }
        
        return KakaoSignInResultModel(
            idToken: oauthToken.idToken ?? "",
            accessToken: oauthToken.accessToken,
            name: account.profile?.nickname,
            email: email
        )
    }
}
