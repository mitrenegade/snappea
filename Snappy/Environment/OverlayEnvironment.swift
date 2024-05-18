//
//  OverlayEnvironment.swift
//  Snappy
//
//  Created by Bobby Ren on 5/18/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation

/// Global environment for viewing an overlay
class OverlayEnvironment: ObservableObject {
    // if a plant exists
    var plant: Plant?

    // if editing a snap
    var isEditingSnap: Bool = false
    var snap: Snap?

    func reset() {
        plant = nil
        isEditingSnap = false
        snap = nil
    }
}
