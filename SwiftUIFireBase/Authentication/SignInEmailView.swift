//
//  SignInEmailView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

@MainActor
final class SingInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email or password found")
            return
        }
        Task {
            do {
                let returnedUserData = try await AuthentivationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error : \(error)")
            }
        }
    }
}

struct SignInEmailView: View {
    @ObservedObject var viewModel = SingInEmailViewModel()
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
                viewModel.signIn()
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
        SignInEmailView(viewModel: SingInEmailViewModel())
    }
}
