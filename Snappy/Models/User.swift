//
//  User.swift
//  Snappy
//
//  Created by Bobby Ren on 5/3/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import RenderCloud

struct User: Decodable, RenderCloud.User {
    var id: String
    var username: String

    init(user: RenderCloud.User) {
        self.id = user.id
        self.username = user.username
    }
}
