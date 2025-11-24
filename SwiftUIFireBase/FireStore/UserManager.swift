//
//  UserManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/4/25.
//
import Foundation
import FirebaseFirestore

struct DBUser {
    let userId: String?
    let email: String?
    let photoURL: String?
    let dataCreated: Date?
}

class UserManager {
    
    static var shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp(),
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoURL = auth.photoURL {
            userData["photo_url"] = photoURL
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userID: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoURL = data["photo_url"] as? String
        let dataCreated = data["data_created"] as? Date
        
        return DBUser(userId: userID, email: email, photoURL: photoURL, dataCreated: dataCreated)
    }
    
   
}
