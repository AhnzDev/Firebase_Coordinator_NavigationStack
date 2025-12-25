//
//  FavoriteView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/22/25.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var products: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
    
    func getFavorite() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
            
            var localArray: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
            
            for userFavoriteProduct in userFavoriteProducts {
                let product = try await ProductsManager.shared.getProduct(productId: String(userFavoriteProduct.productId))
                localArray.append((userFavoriteProduct, product))
            }
            self.products = localArray
        }
    }
    
    func removeFromFaorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            getFavorite()
        }
    }
    
}


struct FavoriteView: View {
    
    @StateObject private var viewModel: FavoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products, id: \.userFavoriteProduct.id.self) { item in
                ProductCellView(product: item.product)
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFaorites(favoriteProductId: item.userFavoriteProduct.id)
                        }
                    }
                
            }
        }
        .navigationTitle("Favorite")
        .onAppear {
            viewModel.getFavorite()
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}
