//
//  User.swift
//  VeggieTag
//
//  Created by Bobby Ren on 5/3/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import UIKit

class User {
    var uid: String?
    var email: String?
    init(uid: String?, email: String?) {
        self.uid = uid
        self.email = email
    }
}
