//
//  ProductsManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/12/25.
//
import Foundation

import FirebaseFirestore


class ProductsManager {
    
    static var shared = ProductsManager()
    private init() { }
    
    private let productCollection = Firestore.firestore().collection("products")
    
    private func productsDocument(productId: String) -> DocumentReference {
        productCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productsDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getAllProducts() async throws -> [Product]{
        let snapShot = try await productCollection.getDocuments()
        
        var products: [Product] = []
        
        for document in snapShot.documents {
            let product = try document.data(as: Product.self)
            products.append(product)
        }
        
        return products
    }
}
