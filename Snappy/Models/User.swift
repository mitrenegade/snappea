//
//  User.swift
//  Snappy
//
//  Created by Bobby Ren on 5/3/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import RenderCloud

struct User {
    var uid: String
    var email: String

    init(user: RenderCloud.User) {
        self.uid = user.id
        self.email = user.username
    }
}
