//
//  CameraRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CameraRoot<T>: View where T: Store {
    @State var image: UIImage? = nil
    @State var showCaptureImageView: Bool = false
    @State private var showingSheet = false
    @State var cameraSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var router: HomeViewRouter
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings

    private let store: T

    init(router: HomeViewRouter, store: T) {
        self.store = store
        self.router = router
    }

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
        Group {
            if image != nil {
                Image(uiImage: image!).resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            }
        }
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
                    Task {
                        if let photo = await self.saveImage() {
                            displayNewPhotoDetail(photo: photo)
                        }
                    }
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
    
    func saveImage() async -> Photo? {
        guard let image else {
            // TODO: throw error
            return nil
        }

        let photo = try? await store.createPhoto(image: image)
        return photo
    }
    
    @MainActor
    func displayNewPhotoDetail(photo: Photo) {
        self.router.selectedTab = .plants
        self.photoDetailSettings.newPhoto = photo
        self.photoDetailSettings.shouldShowNewPhoto = true
    }
}
//
//struct CameraRoot_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraRoot(router: HomeViewRouter(store: MockStore()), store: MockStore())
//    }
//}
