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

    init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
      _isShown = isShown
      _image = image
    }

    func imagePickerController(_ picker: UIImagePickerController,
                  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
       image = unwrapImage
       isShown = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       isShown = false
    }
}
