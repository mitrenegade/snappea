//
//  AddImageHelperLayer.swift
//  Snappy
//
//  Created by Bobby Ren on 3/22/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

/// Manages an action sheet and a CaptureImageView
/// and handles states for selected image or cancel actions
struct AddImageHelperLayer: View {

    /// Display an action sheet to select between camera and photo album
    @State private var showingSheet = true

    /// Display the CaptureImageView whether a camera or photo album
    @State private var showCaptureImageView: Bool = false
    @State private var cameraSourceType: UIImagePickerController.SourceType = .photoLibrary

    /// The selected image
    @Binding var image: UIImage?

    // Used to trigger parent view's state of whether this layer should be dismissed
    @Binding var showingSelf: Bool

    /// Allows the plant gallery to be an option for image source
    var canShowGallery: Bool = false

    /// Whether parent view should show a gallery
    @Binding var shouldShowGallery: Bool

    var store: (any Store)?

    var body: some View {
        ZStack {
            if showCaptureImageView {
                CaptureImageView(isShown: $showCaptureImageView,
                                 image: $image,
                                 mode: $cameraSourceType)
            }
        }
        .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
            makeActionSheet
        }
        .onChange(of: showCaptureImageView) {
            // image selection dismissed
            if showCaptureImageView == false {
                showingSelf = false
            }
        }
        .onChange(of: showingSheet) {
            // if cancel was clicked on the sheet
            if !showingSheet && !showCaptureImageView {
                showingSelf = false
            }
        }
    }

    var makeActionSheet: ActionSheet {
        let title = "Select photo from:"
        var buttons: [ActionSheet.Button] = [
            .default(Text("Photo Library"), action: {
                self.openLibrary()
            }),
            .default(Text("Cancel"))
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            buttons.insert(.default(Text("Camera"), action: {
                self.openCamera()
            }), at: 0)
        }
        if canShowGallery {
            buttons.insert(.default(Text("Snapped Photos"), action: {
                self.openGallery()
            }), at: 0)
        }
        return ActionSheet(title: Text(title), message: nil, buttons: buttons)
    }

    func openCamera() {
        // camera
        self.cameraSourceType = .camera
        self.showCaptureImageView.toggle()
    }

    func openLibrary() {
        // photo album
        self.cameraSourceType = .photoLibrary
        self.showCaptureImageView.toggle()
    }

    func openGallery() {
        // TODO: how to open this as a modal instead?
        showingSelf = false
        shouldShowGallery = true
    }
}
