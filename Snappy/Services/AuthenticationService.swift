//
//  AuthenticationService.swift
//  Snappy
//
//  Created by Bobby Ren on 5/2/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import RenderCloud

class AuthenticationService: ObservableObject {

    static let shared = AuthenticationService()

    private lazy var authService: RenderAuthService = {
        RenderAuthService(delegate: self)
    }()

    @Published var user: User?

    func signInAnonymously() {
        // not used
//        Auth.auth().signInAnonymously()
    }

    func signUp(email: String,
                password: String) {
        Task {
            try await authService.signup(username: email, password: password)
        }
    }

    func signIn(email: String,
                password: String) {
        Task {
            try await authService.login(username: email, password: password)
        }
    }

    func signOut() {
        try? authService.logout()
    }
}

extension AuthenticationService: CloudAuthServiceDelegate {
    func userDidChange(user: RenderCloud.User?) {
        if let user = user {
            // logged in with a user
            self.user = User(user: user)
        }
        else {
            self.user = nil
            print("User signed out.")
        }
    }
}
