//
//  AuthenticationService.swift
//  VeggieTag
//
//  Created by Bobby Ren on 5/2/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Firebase

class AuthenticationService: ObservableObject {
    static let shared: AuthenticationService = AuthenticationService()
    @Published var user: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    func signInAnonymously() {
        // not used
        Auth.auth().signInAnonymously()
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in // (4)
            print("Sign in state has changed with user \(String(describing: user)).")
            if let user = user {
                // logged in with a user
                self.user = User(uid: user.uid, email: user.email)
                
//                // To upload test data
//                APIService.shared.uploadTestData()
            }
            else {
                self.user = nil
                print("User signed out.")
            }
        }
    }
}
