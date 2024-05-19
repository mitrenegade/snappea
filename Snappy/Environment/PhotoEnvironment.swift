//
//  PhotoEnvironment.swift
//  Snappy
//
//  Created by Bobby Ren on 5/17/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

/// Global environment for adding new photos
class PhotoEnvironment: ObservableObject {
    @Published var newPhoto: Photo? = nil
    @Published var shouldShowNewPhoto: Bool = false
    @Published var newImage: UIImage? = nil

    // if true, returns to plant gallery
    @Published var isAddingPhotoToPlant: Bool = false

    func reset() {
        newPhoto = nil
        shouldShowNewPhoto = false
        isAddingPhotoToPlant = false
    }
}
