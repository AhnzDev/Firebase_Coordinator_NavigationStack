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
    let dateCreated: Date?
    let isPremium: Bool?
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
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
        self.dateCreated = dataCreated
        self.isPremium = isPremium
    }
    
//    func togglePremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//        return DBUser(userId: userId,
//                      email: email,
//                      photoURL: photoURL,
//                      dataCreated: dataCreated,
//                      isPremium: !currentValue)
//    }
    
    mutating func togglePremiumStatus(){
        let currentValue = isPremium ?? false
//        isPremium = !currentValue
    }
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoURL = "photo_url"
        case dataCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dataCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }

    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dataCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
}

class UserManager {
    
    static var shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user:DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
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
        try await userDocument(userId: userID).getDocument(as: DBUser.self, decoder: decoder)
        
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
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
   
    func updateUserPremiumStatus(userId: String,isPremium: Bool) async throws {
        var data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }

}
