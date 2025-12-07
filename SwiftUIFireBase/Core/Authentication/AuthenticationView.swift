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




struct AuthenticationView: View {
    let appleProducts: [String] = ["Mac", "Macbook", "iPhone", "iPad"]
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @EnvironmentObject private var naviPathFinder: NavigationPathFinder
    
    
    var body: some View {
        NavigationStack(path: $naviPathFinder.path){
            VStack {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInAnonymous()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    Text("Sign In Anonymously")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                })
                
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
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                
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
                .frame(height: 50)
                
                KakaoLoginButton {
                    Task {
                        do {
                            try await viewModel.signInKakao()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
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
            .alert("로그인 오류", isPresented: $viewModel.showError) {
                Button("확인") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
        .environmentObject(NavigationPathFinder.shared)
    
}

struct KakaoLoginButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "message.fill") // 카카오 로고 대신 심볼 사용 (임시)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.black)
                
                Text("카카오로 로그인")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(red: 1.0, green: 0.9, blue: 0.0)) // #FEE500 (카카오 노란색)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
            )
        }
    }
}
