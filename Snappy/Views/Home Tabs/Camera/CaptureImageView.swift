//
//  CameraView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CaptureImageView {
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    @Binding var mode: UIImagePickerController.SourceType

    /// `true` if image is true; needed to update parent view since `image != nil`
    /// won't trigger any updates in the UI
    @Binding var isImageSelected: Bool

    // MARK: - UIViewControllerRepresentable

    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image, isImageSelected: $isImageSelected)
    }

    init(isShown: Binding<Bool>, image: Binding<UIImage?>, mode: Binding<UIImagePickerController.SourceType>, isImageSelected: Binding<Bool>) {
        _isImageSelected = isImageSelected
        _image = image
        _isShown = isShown
        _mode = mode
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = self.mode
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        print("BRDEBUG updated image != nil? \(image != nil) isImageSelected \(isImageSelected) isShown \(isShown)")
    }
}
