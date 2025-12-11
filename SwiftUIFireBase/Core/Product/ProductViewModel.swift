//
//  ProductViewModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/12/25.
//
import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class ProductViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    
    
        func downloadProductsAndUploadToFirebase() {
            guard let url = URL(string: "https://dummyjson.com/products") else { return }
    
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let products = try JSONDecoder().decode(ProductArray.self, from: data)
                    let productArray = products.products
    
                    for product in productArray {
                        try? await ProductsManager.shared.uploadProduct(product: product)
                    }
    
                    print("SUCCESS")
                    print(products.products.count)
                } catch {
                    print(error)
                }
            }
        }
    
    func getProducts() {
        Task {
            do {
                products = try await ProductsManager.shared.getAllProducts()
            } catch {
                print(error)
            }
        }
    }
}
