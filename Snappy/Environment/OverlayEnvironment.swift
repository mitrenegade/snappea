//
//  OverlayEnvironment.swift
//  Snappy
//
//  Created by Bobby Ren on 5/18/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit

/// Global environment for viewing an overlay
class OverlayEnvironment: ObservableObject {
    // BR TODO: use a mode so they're mutually exclusive

    // if a plant exists
    var plant: Plant?

    // if editing a snap
    var isEditingSnap: Bool = false
    var snap: Snap?

    // if adding a new snap to an image
    var isAddingSnap: Bool = false
    var image: UIImage?

    func reset() {
        plant = nil
        isEditingSnap = false
        snap = nil
        isAddingSnap = false
        image = nil
    }
}
