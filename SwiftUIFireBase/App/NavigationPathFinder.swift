//
//  NavigationPathFinder.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/12/25.
//

import Foundation
import SwiftUI

enum ViewOption: Hashable {
    case homeFirst(champion: ChampionModel)
    case homeSecond(champion: ChampionModel)
    case signInEmail
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .homeFirst(let champion): HomeRowDestinationView(champion: champion)
        case .homeSecond(let champion): HomeSkinBuyView(champion: champion)
        case .signInEmail: RootView()
        }
    }
}

enum BindingViewOption: String, Hashable {
    case signInEmail
    case googleSignIn
}

final class NavigationPathFinder: ObservableObject {
    static let shared = NavigationPathFinder()
    
    private init() { }
    
    @Published var path: NavigationPath = .init()
    
    @State var showInEmailView: Bool = false
    
    func addPath(option: ViewOption) {
        path.append(option)
    }
    func popToRoot() {
        path = .init()
    }
}

final class ViewStateStore: ObservableObject {
    static let shared = ViewStateStore()
    
    private init() { }
    @Published var showInEmailView: Bool = false
}
