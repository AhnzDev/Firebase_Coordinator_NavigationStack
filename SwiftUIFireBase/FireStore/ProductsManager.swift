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
    
    func getProduct(productId: String) async throws -> Product {
        try await productsDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product]{
        try await productCollection.getDocuments(as: Product.self)
    }
    
    func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product]{
        try await productCollection.order(by: "price", descending: descending).getDocuments(as: Product.self)
    }
    
    func getAllProductsForCategory(category: String) async throws -> [Product]{
        try await productCollection.whereField("category", isEqualTo: category).getDocuments(as: Product.self)
    }
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapShot = try await self.getDocuments()
        
        return try snapShot.documents.map { document in
            return try document.data(as: T.self)
        }
        
    }
}
