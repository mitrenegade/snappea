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
    @Binding var shouldDismiss: Bool

    var body: some View {
        ZStack {
            if showCaptureImageView {
                CaptureImageView(isShown: $showCaptureImageView,
                                 image: $image,
                                 mode: $cameraSourceType,
                                 isImageSelected: $shouldDismiss)
            }
        }
        .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
            makeActionSheet
        }
        .onChange(of: showCaptureImageView) {
            // image selection dismissed
            if showCaptureImageView == false {
                shouldDismiss = true
            }
        }
        .onChange(of: showingSheet) {
            // if cancel was clicked on the sheet
            if !showingSheet && !showCaptureImageView {
                shouldDismiss = true
            }
        }
    }

    var makeActionSheet: ActionSheet {
        let title = "Select photo from:"
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return ActionSheet(title: Text(title), message: nil, buttons:[
                .default(Text("Camera"), action: {
                    self.openCamera()
                }),
                .default(Text("Photo Album"), action: {
                    self.openLibrary()
                }),
                .default(Text("Cancel"))
            ])
        } else {
            return ActionSheet(title: Text(title), message: nil, buttons:[
                .default(Text("Photo Album"), action: {
                    self.openLibrary()
                }),
                .default(Text("Cancel"))
            ])
        }
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

}
