//
//  Query+Ext.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/27/25.
//
import Combine
import Foundation

import FirebaseFirestore

extension Query {
    
//    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
//        let snapShot = try await self.getDocuments()
//
//        return try snapShot.documents.map { document in
//            return try document.data(as: T.self)
//        }
//    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapShot(as: type).product
    }
    
    func getDocumentsWithSnapShot<T>(as type: T.Type) async throws -> (product: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapShot = try await self.getDocuments()
        
        let products = try snapShot.documents.map { document in
            return try document.data(as: T.self)
        }
        
        return (products, snapShot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?)-> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws-> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
