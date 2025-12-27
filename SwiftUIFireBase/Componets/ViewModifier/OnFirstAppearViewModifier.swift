//
//  Untitled.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/27/25.
//

import SwiftUI


struct OnFirstAppearViewModifier: ViewModifier {
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    // content는 이전 바디에 있던 전체뷰 정보
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
    
}
