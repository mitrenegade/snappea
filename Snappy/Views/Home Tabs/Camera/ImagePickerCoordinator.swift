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
    @Binding var isImageSelected: Bool

    init(isShown: Binding<Bool>, image: Binding<UIImage?>, isImageSelected: Binding<Bool>) {
        _isShown = isShown
        _image = image
        _isImageSelected = isImageSelected
    }

    func imagePickerController(_ picker: UIImagePickerController,
                  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        image = unwrapImage
        isShown = false
        isImageSelected = image != nil
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
        isImageSelected = false
    }
}
