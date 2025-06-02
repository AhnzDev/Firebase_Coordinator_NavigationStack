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


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
  
    @Published var didSignInWithApple: Bool = false
    let helper = SignInAppleHelper()
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
    }
    
    func signInApple() async throws{
        helper.startSignInWithAppleFlow()
        startSignInWithAppleFlow()
        /*
         do {
             try await AuthenticationManager.shared.signInWithApple(tokens: result)
             didSignInWithApple = true
         } catch {
             didSignInWithApple = false
         }
         */
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
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                }
                .frame(height: 55)
                .onChange(of: viewModel.didSignInWithApple) { newValue in
                    if newValue {
                        viewModel.startSignInWithAppleFlow()
                    }
                }
                
                
                
            }
            .padding()
            .navigationTitle("Sing In")
            .navigationDestination(for: ViewOption.self) { option in
                option.view()
            }
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
