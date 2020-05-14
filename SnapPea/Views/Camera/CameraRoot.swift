//
//  CameraRoot.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CameraRoot: View {
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    @State private var showingSheet = false
    @State var cameraSourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        ZStack {
            NavigationView{
                VStack {
                    imagePreview
                    captureImageButton
                }
                .navigationBarItems(leading: cancelButton,
                                    trailing: saveButton
                )
            }
            if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, image: $image, mode: $cameraSourceType)
            }
        }
    }
    
    var imagePreview: some View {
        image?.resizable()
        .frame(width: 250, height: 250)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
    
    var captureImageButton: some View {
        Button(action: {
            self.showingSheet.toggle()
        }) {
            if image == nil {
                Text("Add photo")
            } else {
                Text("Change photo")
            }
        }
        .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
            makeActionSheet
        }
    }
    
    var cancelButton: some View {
        Group {
            if image != nil {
                Button(action: {
                    // cancel
                    self.image = nil
                }) {
                    Text("Cancel")
                }
            }
        }
    }

    var saveButton: some View {
        Group {
            if image != nil {
                Button(action: {
                    // save
                    self.saveImage()
                }) {
                    Text("Save")
                }
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
    
    func saveImage() {
        FirebaseImageService.uploadImage(image: image?.rawImage, type: .photo, uid: <#String#>)
    }
}

struct CameraRoot_Previews: PreviewProvider {
    static var previews: some View {
        CameraRoot()
    }
}
