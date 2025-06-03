//
//  AuthenticationView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 4/30/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import _AuthenticationServices_SwiftUI
import CryptoKit
import KakaoSDKUser


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
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
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    UserApi.shared.me { user, error in
                        guard let account = user?.kakaoAccount else {
                            print("카카오 계정 정보 없음")
                            return
                        }

                        if let email = account.email {
                            print("✅ 이메일: \(email)")
                        } else if account.emailNeedsAgreement == true {
                            print("⚠️ 이메일 항목에 대해 추가 동의 필요")
                        } else {
                            print("❌ 이메일 없음 또는 제공 불가")
                        }
                    }
                }
                
                
            }
        } else {
            
        }

    }
}




struct AuthenticationView: View {
    let appleProducts: [String] = ["Mac", "Macbook", "iPhone", "iPad"]
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @EnvironmentObject private var naviPathFinder: NavigationPathFinder
    
    
    var body: some View {
        NavigationStack(path: $naviPathFinder.path){
            VStack {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .onTapGesture {
                        naviPathFinder.path.append(BindingViewOption.signInEmail)
                    }
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .standard, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                Button {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                }
                .frame(height: 55)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signInKakao()
                            
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("KaKao")
                }
                .frame(height: 55)
            }
            .padding()
            .navigationTitle("Sing In")
            .navigationDestination(for: ViewOption.self) { option in
                option.view()
            }
            .onAppear(perform: {
                debugPrint(#fileID,#function,"ahnz - ")
            })
            .navigationDestination(for: BindingViewOption.self) { bindingViewOption in
                switch bindingViewOption {
                case .signInEmail:
                    SignInEmailView(showSignInView: $showSignInView)
                case .googleSignIn:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
        .environmentObject(NavigationPathFinder.shared)
    
}
