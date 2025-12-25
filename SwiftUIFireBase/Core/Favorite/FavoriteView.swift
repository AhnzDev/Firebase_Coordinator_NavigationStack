//
//  FavoriteView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/22/25.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    
    func addListnerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
            guard let self = self else { return }
            self.userFavoriteProducts = products
        }
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


struct FavoriteView: View {
    
    @StateObject private var viewModel: FavoriteViewModel = FavoriteViewModel()
    @State private var didAppear: Bool = false
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFaorites(favoriteProductId: item.id)
                        }
                    }
                
            }
        }
        .navigationTitle("Favorite")
        .onAppear {
            if !didAppear {
                viewModel.addListnerForFavorites()
                didAppear = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}
