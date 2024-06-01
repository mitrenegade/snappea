//
//  Constants.swift
//  Snappy
//
//  Created by Bobby Ren on 12/11/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

let TESTING = true
let AIRPLANE_MODE = false

struct Global {
    // Firebase
    /*
    static let storeFactory = {
        FirebaseStore()
    }
    static let imageLoaderFactory = {
        FirebaseImageLoader()
    }
     */

    // Local
    static let storeFactory = {
        LocalStore()
    }
    static let imageLoaderFactory = {
        DiskImageLoader(baseUrl: LocalStore().imageBaseURL)
    }

}
