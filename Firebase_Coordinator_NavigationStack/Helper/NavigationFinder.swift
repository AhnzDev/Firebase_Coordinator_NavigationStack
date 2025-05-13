//
//  NavigationFinder.swift
//  Firebase_Coordinator_NavigationStack
//
//  Created by Jihoon on 5/12/25.
//

import SwiftUI

enum ViewOption: Hashable {
    case intro
    case email
    case login
    case main
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .intro: HomeView()
        case .email: Text("Email")
        case .login: HomeView()
        case .main: HomeView()
        }
    }
}

class NavigationFinder: ObservableObject {
    static let shared: NavigationFinder = NavigationFinder()
    var path: NavigationPath = .init()
    init() { }
    
    public func addPath(option: ViewOption) {
        path.append(option)
    }
    
    public func popPath() {
        path.removeLast()
    }
    
}
