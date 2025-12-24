//
//  FavoriteView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/22/25.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    
    func getFavorite() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
            
            for userFavoriteProduct in userFavoriteProducts {
                let product = try await ProductsManager.shared.getProduct(productId: String(userFavoriteProduct.productId))
                products.append(product)
            }
            
        }
    }
    
}


struct FavoriteView: View {
    
    @StateObject private var viewModel: FavoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                
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
