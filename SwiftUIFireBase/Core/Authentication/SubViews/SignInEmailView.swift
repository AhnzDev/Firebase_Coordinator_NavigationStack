//
//  SignInEmailView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

struct SignInEmailView: View {
    @ObservedObject var viewModel = SingInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                    } catch {
                        debugPrint("\(type(of: self))",#function,#line, "jha - \(error)")
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    } catch {
                        debugPrint("\(type(of: self))",#function,#line, "jha - \(error)")
                    }
                    
               
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
            Spacer()

        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(viewModel: SingInEmailViewModel(), showSignInView: .constant(false))
    }
}
