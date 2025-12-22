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
