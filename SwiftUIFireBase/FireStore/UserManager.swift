//
//  UserManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/4/25.
//
import Foundation
import FirebaseFirestore

struct DBUser: Codable { // Encodable & Decodable
    let userId: String
    let email: String?
    let photoURL: String?
    let dataCreated: Date?
    let isPremium: Bool?
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dataCreated = Date()
        self.isPremium = false
    }
    
    init(
        userId: String,
        email: String? = nil,
        photoURL: String? = nil,
        dataCreated: Date? = nil,
        isPremium: Bool? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.dataCreated = dataCreated
        self.isPremium = isPremium
    }
}

class UserManager {
    
    static var shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let enCoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let deCoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user:DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: enCoder)
    }
//    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String: Any] = [
//            "user_id" : auth.uid,
//            "date_created" : Timestamp(),
//        ]
//        if let email = auth.email {
//            userData["email"] = email
//        }
//        if let photoURL = auth.photoURL {
//            userData["photo_url"] = photoURL
//        }
//        
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//    }
    
    func getUser(userID: String) async throws -> DBUser {
        try await userDocument(userId: userID).getDocument(as: DBUser.self)
        
    }
//    
//    func getUser(userID: String) async throws -> DBUser {
//        let snapshot = try await userDocument(userId: userID).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let email = data["email"] as? String
//        let photoURL = data["photo_url"] as? String
//        let dataCreated = data["data_created"] as? Date
//        
//        return DBUser(userId: userID, email: email, photoURL: photoURL, dataCreated: dataCreated)
//    }
//
    
    func updateUserPremiumStatus(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: enCoder)
    }
   
}
