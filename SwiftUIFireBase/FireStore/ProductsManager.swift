//
//  ProductsManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/12/25.
//
import Foundation

import FirebaseFirestore
import Combine


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
    
//    private  func getAllProducts() async throws -> [Product]{
//        try await productCollection
//            .getDocuments(as: Product.self)
//    }
//    
//    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product]{
//        try await productCollection
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocuments(as: Product.self)
//    }
//    
//    private func getAllProductsForCategory(category: String) async throws -> [Product]{
//        try await productCollection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category).getDocuments(as: Product.self)
//    }
//    
//    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
//        try await productCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocuments(as: Product.self)
//    }
    private  func getAllProductsQuery() -> Query{
        productCollection
    }
    
    private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query{
        productCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getAllProductsForCategoryQuery(category: String) -> Query {
       productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (product : [Product], lastDocument: DocumentSnapshot?) {
        
        var query: Query = getAllProductsQuery()
        
        if let descending, let category {
            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapShot(as: Product.self)
        
        if let lastDocument {
            return try await query
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapShot(as: Product.self)
        } else {
            return try await query
                .limit(to: count)
                .getDocumentsWithSnapShot(as: Product.self)
        }
    }

    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
        try await productCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 99999999])
            .getDocuments(as: Product.self)
    }
    
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (product : [Product], lastDocument: DocumentSnapshot?) {
        if let lastDocument {
            return try await productCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapShot(as: Product.self)
        } else {
            return try await productCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsWithSnapShot(as: Product.self)
        }
    }
    
    func getAllProductsCount() async throws -> Int {
        try await productCollection
            .aggregateCount()
    }
    
}

