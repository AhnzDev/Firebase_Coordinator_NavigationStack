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
    case product(product: String)
    case signInEamil
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .homeFirst(let champion): HomeRowDestinationView(champion: champion)
        case .homeSecond(let champion): HomeSkinBuyView(champion: champion)
        case .product(let product): AppleProductView(product: product)
        case .signInEamil: SignInEmailView()
        }
    }
}

final class NavigationPathFinder: ObservableObject {
    static let shared = NavigationPathFinder()
    
    private init() { }
    
    @Published var path: NavigationPath = .init()
    
    func addPath(option: ViewOption) {
        path.append(option)
    }
    func popToRoot() {
        path = .init()
    }
    
}
