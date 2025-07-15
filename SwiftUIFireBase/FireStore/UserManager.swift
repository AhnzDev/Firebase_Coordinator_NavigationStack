//
//  UserManager.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 7/4/25.
//
import Foundation
import FirebaseFirestore

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
    
}
