//
//  PhotoDetailSettings.swift
//  Snappy
//
//  Created by Bobby Ren on 5/17/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

class PhotoDetailSettings: ObservableObject {
    @Published var selectedTab: Tab = .plants

    @Published var newPhoto: Photo? = nil
    @Published var shouldShowNewPhoto: Bool = false

    @Published var isAddingPhotoToPlant: Bool = false
}
