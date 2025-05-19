//
//  AuthenticationView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 4/30/25.
//

import SwiftUI

struct AuthenticationView: View {
    let appleProducts: [String] = ["Mac", "Macbook", "iPhone", "iPad"]
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
                        naviPathFinder.addPath(option: .signInEamil)
                    }
                
        
            }
            .padding()
            .navigationTitle("Sing In")
            .navigationDestination(for: ViewOption.self) { option in
                option.view()
            }
        }
    }
}



struct AppleProductView: View {
    let product: String
    @EnvironmentObject private var naviPathFinder: NavigationPathFinder
    
    var body: some View {
        VStack(spacing: 20) {
            Text(product)
                .font(.largeTitle)
                .onTapGesture {
                    naviPathFinder.addPath(option: .product(product: "세번째혹은 더 깊이"))
                }
            
            Text("모두 없애 버려 ")
                .font(.largeTitle)
                .onTapGesture {
                    naviPathFinder.popToRoot()
                }
        }
    }
}


struct TableCell: View {
    var body: some View {
        VStack (spacing: 20){
            Image(systemName: "icloud.fill")
                .resizable()
                .frame(width: 50, height: 50)
            Text("클라우드")
        }.padding(0)
    }
}

#Preview {
        AuthenticationView()
        .environmentObject(NavigationPathFinder.shared)
    
}
