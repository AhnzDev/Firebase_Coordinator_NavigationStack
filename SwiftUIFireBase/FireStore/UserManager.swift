//
//  UserManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/4/25.
//
import Foundation
import FirebaseFirestore

struct Movies: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable { // Encodable & Decodable
    let isAnonymous: Bool?
    let userId: String
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovies: Movies?
    
    init(auth: AuthDataResultModel){
        self.isAnonymous = auth.isAnonymous
        self.userId = auth.uid
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovies = nil
    }
    
    init(
        isAnonymous: Bool? = nil,
        userId: String,
        email: String? = nil,
        photoURL: String? = nil,
        dataCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoriteMovies: Movies? = nil
    ) {
        self.isAnonymous = isAnonymous
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dataCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovies = favoriteMovies
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
        case isAnonymous = "is_anonymous"
        case userId = "user_id"
        case email = "email"
        case photoURL = "photo_url"
        case dataCreated = "date_created"
        case isPremium = "is_premium"
        case preferences = "preferences"
        case favoriteMovies = "favorite_movies"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isAnonymous, forKey: .isAnonymous)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dataCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favoriteMovies, forKey: .favoriteMovies)
    }

    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isAnonymous = try container.decode(Bool.self, forKey: .isAnonymous)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dataCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favoriteMovies = try container.decodeIfPresent(Movies.self, forKey: .favoriteMovies)
    }
}

class UserManager {
    
    static var shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_products")
    }
    
    private func userFavoriteProductDocument(userId: String, favoriteProductId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(favoriteProductId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var userFavoriteProductListner: ListenerRegistration? = nil
    
    func createNewUser(user:DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
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
    
//    func updateUserPremiumStatus(user: DBUser) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
   
    func updateUserPremiumStatus(userId: String,isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreferences(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreferences(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserFavoriteMovie(userId: String, movies: Movies) async throws {
        guard let data = try? encoder.encode(movies) else {
            throw URLError(.badURL)
        }
        let dict: [String: Any] = [
            DBUser.CodingKeys.favoriteMovies.rawValue : data
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeUserFavoriteMovie(userId: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.favoriteMovies.rawValue : nil
        ]
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }

    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        let document = userFavoriteProductCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            "id" : documentId,
            "product_id" : productId,
            "date_created" : Timestamp()
        ]
        try await document.setData(data, merge: false) // AutoID Generate
    }
    
    func removeUserFavoriteProduct(userId: String, favoriteProductId: String) async throws {
        try await userFavoriteProductDocument(userId: userId, favoriteProductId: favoriteProductId).delete()
    }
    
    func getAllUserFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct]{
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListnerForAllUserFavoriteProducts() {
        self.userFavoriteProductListner?.remove()
    }
    
    func addListenerForAllUserFavoriteProducts(userId: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
        self.userFavoriteProductListner = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot?.documents else {
                print("empty Documents")
                return
            }
            let products: [UserFavoriteProduct] = document.compactMap( { try? $0.data(as: UserFavoriteProduct.self) })
            completion(products)
        }
        
    }
}

struct UserFavoriteProduct: Codable {
    let id: String
    let productId: Int
    let dateCreated: Date
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
}
