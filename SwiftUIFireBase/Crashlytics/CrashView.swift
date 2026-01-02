//
//  CrashView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/31/25.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack {
                Button("Click me 1") {
                    let myString: String? = nil
                    let string2 = myString!
                }
                Button("Click me 2") {
                    fatalError("Crash was triggered")
                }
            }
        }
    }
}

#Preview {
    CrashView()
}
