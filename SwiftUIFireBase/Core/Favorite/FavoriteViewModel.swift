//
//  FavoriteViewModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/27/25.
//

import Combine
import Foundation

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListnerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                debugPrint(#fileID,#function,"ahnz - ")
            } receiveValue: { products in
                self.userFavoriteProducts = products
            }.store(in: &cancellables)

        
//        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
//            guard let self = self else { return }
//            self.userFavoriteProducts = products
//        }
    }
    
//    func getFavorite() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//        }
//    }
    
    func removeFromFaorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
//            getFavorite()
        }
    }
    
}
