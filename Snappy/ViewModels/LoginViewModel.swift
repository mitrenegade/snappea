//
//  LoginViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 5/2/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import RenderCloud

class LoginViewModel: ObservableObject {

    private lazy var auth: RenderAuthService = {
        RenderAuthService(delegate: self)
    }()

    @Published var isLoggedIn = false
    @Published var user: User?

    func signUp(email: String,
                password: String) async throws {
        _ = try await auth.signup(username: email, password: password)
    }

    func signIn(email: String,
                password: String) async throws {
        _ = try await auth.login(username: email, password: password)
    }

    func signOut() {
        try? auth.logout()
    }
}

extension LoginViewModel: CloudAuthServiceDelegate {
    func userDidChange(user: RenderCloud.User?) {
        if let user = user {
            // logged in with a user
            self.user = User(user: user)
            self.isLoggedIn = true
        }
        else {
            self.isLoggedIn = false
            print("User signed out.")
        }
    }
}
