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
                            showSignInView = false
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
