//
//  SettingsView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/19/25.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.logOut()
//                        azLog("이렇게 하면 됨 \(showSignInView)")
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
//                Text("Log Out")
                CustomView()
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
//            AZLogger.azOsLog("앱이 실행 됐습니다",level: .error)
        }
        .navigationTitle("Settings")
        // ✅ 새로운 이메일 입력 다이얼로그
        .alert("이메일 변경", isPresented: $viewModel.showEmailUpdateAlert) {
            TextField("새 이메일 주소", text: $viewModel.newEmail)
            Button("다음") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                    } catch {
                        viewModel.alertMessage = "이메일 변경 실패: \(error.localizedDescription)"
                        viewModel.showAlert = true
                    }
                }
            }
            Button("취소", role: .cancel) {
                viewModel.clearAlerts()
            }
        } message: {
            Text("새로운 이메일 주소를 입력해주세요.")
        }
        // ✅ 비밀번호 확인 다이얼로그 (이메일/패스워드 사용자용)
        .alert("현재 비밀번호 확인", isPresented: $viewModel.showPasswordPrompt) {
            SecureField("현재 비밀번호", text: $viewModel.currentPassword)
            Button("변경") {
                Task {
                    try await viewModel.updateEmailWithPassword()
                }
            }
            Button("취소", role: .cancel) {
                viewModel.clearAlerts()
            }
        } message: {
            Text("보안을 위해 현재 비밀번호를 입력해주세요.")
        }
        // ✅ 일반 알림 다이얼로그
        .alert("알림", isPresented: $viewModel.showAlert) {
            Button("확인") {
                viewModel.clearAlerts()
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

extension SettingsView{
    
    private var emailSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Reset Password")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update Password")
            }
            
            Button {
                viewModel.requestEmailUpdate()
            } label: {
                Text("Update Email")
            }
        } header: {
            Text ("Email Function")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: Binding.constant(false))
    }
}

struct CustomView: View {
    var body: some View {
        HStack(spacing: 50){
            Image(systemName: "bolt")
                .foregroundStyle(.black)
                .clipShape(.capsule)
            Text("볼트")
                .foregroundStyle(.black)
        }
    }
}
