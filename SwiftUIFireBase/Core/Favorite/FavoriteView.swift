//
//  FavoriteView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/22/25.
//
import Combine
import SwiftUI



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
        .onFirstAppear {
            viewModel.addListnerForFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView()
    }
}

