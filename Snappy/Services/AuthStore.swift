//
//  AuthService.swift
//  Snappy
//
//  Created by Bobby Ren on 12/13/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

/// Storage for user and login state
/// Use in a similar way to Keychain, not LoginViewModel
class AuthStore: ObservableObject {
    static let shared = AuthStore()

    var user: User? = nil {
        didSet {
            isLoggedIn = user != nil
        }
    }

    @Published var isLoggedIn: Bool = false
}
