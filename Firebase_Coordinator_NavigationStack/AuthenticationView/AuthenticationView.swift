//
//  AuthenticationView.swift
//  Firebase_Coordinator_NavigationStack
//
//  Created by Jihoon on 5/14/25.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack {
            Button {
                NavigationFinder.shared.addPath(option: .email)
            } label: {
                Text("Sing In With Email")
            }

        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AuthenticationView()
}
