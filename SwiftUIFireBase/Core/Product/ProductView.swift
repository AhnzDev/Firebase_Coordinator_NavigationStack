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
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear {
                            print("PROGRESS VIEW APPEARED")
                            viewModel.getProducts()
                        }
                }

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
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "None")") {
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
            viewModel.getProductCount()
        }
    }
}

#Preview {
    NavigationStack {
        ProductView()
    }
}
