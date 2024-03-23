//
//  CameraRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CameraRoot<T>: View where T: Store {

    /// Image picker layer
    @State private var showingAddImageLayer = false
    @State var image: UIImage? = nil
    @State private var imageSelected = false

    @EnvironmentObject var photoEnvironment: PhotoEnvironment
    @EnvironmentObject var router: TabsRouter

    private let store: T

    init(store: T) {
        self.store = store
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
            if showingAddImageLayer && !imageSelected {
                AddImageHelperLayer(image: $image, imageSelected: $imageSelected)
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
            self.showingAddImageLayer.toggle()
            self.imageSelected = false
        }) {
            if image == nil {
                Text("Add photo")
            } else {
                Text("Change photo")
            }
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

    func saveImage() async -> Photo? {
        guard let image else {
            // TODO: throw error
            return nil
        }

        do {
            let photo = try await store.createPhoto(image: image)
            return photo
        } catch {
            print("Save photo error \(error)")
            return nil
        }
    }
    
    @MainActor
    func displayNewPhotoDetail(photo: Photo) {
        self.router.selectedTab = .gallery
        self.photoEnvironment.newPhoto = photo
        self.photoEnvironment.shouldShowNewPhoto = true
    }
}
//
//struct CameraRoot_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraRoot(router: HomeViewRouter(store: MockStore()), store: MockStore())
//    }
//}
