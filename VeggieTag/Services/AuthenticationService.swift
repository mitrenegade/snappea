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
  @Published var user: User? // (1)
  
  func signIn() {
    registerStateListener() // (2)
    Auth.auth().signInAnonymously() // (3)
  }
  
  private func registerStateListener() {
    Auth.auth().addStateDidChangeListener { (auth, user) in // (4)
      print("Sign in state has changed.")
      self.user = user
      
      if let user = user {
        let anonymous = user.isAnonymous ? "anonymously " : ""
        print("User signed in \(anonymous)with user ID \(user.uid).")
      }
      else {
        print("User signed out.")
      }
    }
  }
}
