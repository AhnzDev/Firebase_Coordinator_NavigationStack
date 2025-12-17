//
//  ProductView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/12/25.
//

import SwiftUI



struct ProductView: View {
    
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        List {
//            Button("FETCH MORE OBJECT") {
//                viewModel.getProductByRating()
//            }
            
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)

            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .navigation) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "None")") {
                    ForEach(ProductViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: option)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.categoryFilter?.rawValue ?? "None")") {
                    ForEach(ProductViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
        })
        .task {
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductView()
    }
}
