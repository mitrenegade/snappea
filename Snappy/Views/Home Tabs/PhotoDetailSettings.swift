//
//  PhotoDetailSettings.swift
//  SnapPea
//
//  Created by Bobby Ren on 5/17/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

class PhotoDetailSettings: ObservableObject {
    @Published var newPhoto: Photo? = nil
    @Published var shouldShowNewPhoto: Bool = false
}
