//
//  SettingsView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func logOut() throws {
        try AuthentivationManager.shared.signOut()
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log Out")
            }
            .navigationTitle("Settings")

        }
        
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: Binding.constant(false))
    }
}
