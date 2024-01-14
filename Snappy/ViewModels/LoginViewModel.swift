//
//  LoginViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 5/2/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import RenderCloud

class LoginViewModel {

    private lazy var auth: CloudAuthService = {
        RenderAuthService(delegate: self)
    }()

    private lazy var store: AuthStore = AuthStore.shared

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

    init() {
        if AIRPLANE_MODE {
            self.userDidChange(user: Stub.testUser)
        } else {
            // start cloud service and listen for existing user
            let _ = auth
        }
    }
}

extension LoginViewModel: CloudAuthServiceDelegate {
    func userDidChange(user: RenderCloud.User?) {
        if let user = user {
            // logged in with a user
            store.user = User(user: user)
        }
        else {
            store.user = nil
            print("User signed out.")
        }
    }
}
