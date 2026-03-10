//
//  AuthManager.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    
    @Published var user: FirebaseAuth.User?
    private let db = Firestore.firestore()
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    func register(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user{
                self.user = user
                completion(.success(user))
                self.createNewPlayerProfile(user: user)
            }
        }
    }
    
    private func createNewPlayerProfile(user: User) {
        let profile = PlayerProfile(id: user.uid, email: user.email ?? "")
        
        do {
            try db.collection("players").document(user.uid).setData(from: profile)
            print("DEBUG: Successfully saved player to Firestore")
        } catch {
            print("DEBUG: Failed to save player: \(error.localizedDescription)")
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error{
                completion(.failure(error))
            } else if let user = result?.user{
                self.user = user
                
                let db = Firestore.firestore()
                db.collection("players").document(user.uid).updateData([
                    "lastLoginAt": FieldValue.serverTimestamp()
                ])
                
                completion(.success(user))
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error Signing Out: \(error.localizedDescription)")
        }
    }
}
