//
//  ProductCellViewBuilder.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/25/25.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .background(Color.red)
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "1")
}
