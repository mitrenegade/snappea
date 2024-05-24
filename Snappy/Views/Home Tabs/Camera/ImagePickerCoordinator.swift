//
//  ImagePicker.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    @Binding var didCancel: Bool

    init(isShown: Binding<Bool>, image: Binding<UIImage?>, didCancel: Binding<Bool>) {
        _isShown = isShown
        _image = image
        _didCancel = didCancel
    }

    func imagePickerController(_ picker: UIImagePickerController,
                  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        image = unwrapImage
        isShown = false
        didCancel = image == nil
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
        didCancel = true
    }
}
