//
//  AddImageHelperLayer.swift
//  Snappy
//
//  Created by Bobby Ren on 3/22/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct AddImageHelperLayer: View {

    @State private var showingSheet = true
    @State private var showCaptureImageView: Bool = false
    @State private var cameraSourceType: UIImagePickerController.SourceType = .photoLibrary

    @State private var imageSelected: Bool = false {
        didSet {
            selfIsShowing = !imageSelected
        }
    }

    @Binding var image: UIImage?
    // Used to trigger parent view's state of whether this layer should be dismissed
    @Binding var selfIsShowing: Bool

    var body: some View {
        ZStack {
            if showCaptureImageView {
                CaptureImageView(isShown: $showCaptureImageView,
                                 image: $image,
                                 mode: $cameraSourceType,
                                 isImageSelected: $imageSelected)
            }

            /// This should be a clear view on top of the calling view
            Text("Add Image Helper Layer")
                .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
                    makeActionSheet
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
