//
//  AddPhotoView.swift
//  Snappy
//
//  Created by Bobby Ren on 3/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddPhotoToPlantView<T>: View where T: Store {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Image picker
    @State var showCaptureImageView: Bool = true {
        didSet {
            print("BRDEBUG showCaptureImageView \(showCaptureImageView)")
        }
    }
    @State var cameraSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var image: UIImage? = nil

    @ObservedObject var store: T

    private let plant: Plant

    @State var isSaveButtonEnabled: Bool = false

    private var title: String {
        if TESTING {
            return "AddPhotoToPlantView"
        } else {
            return "Add Photo"
        }
    }

    init(store: T, plant: Plant) {
        self.store = store
        self.plant = plant
    }

    var body: some View {
        Text(title)
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView,
                                     image: $image,
                                     mode: $cameraSourceType,
                                     isImageSelected: $isSaveButtonEnabled)
                }

            }
        }
        .navigationBarItems(trailing: saveButton)
//        .alert(isPresented: $viewModel.isShowingError) {
//            Alert(title: Text(viewModel.errorMessage ?? "Unknown error"))
//        }

    }

    private var saveButton: some View {
        Button(action: {
            guard let image else {
                return
            }
            Task {
                await saveImage(image: image, plant: plant)
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }) {
            Text("Save")
        }
        .disabled(!isSaveButtonEnabled)
    }
}

// TODO: move this to a common photo class
extension AddPhotoToPlantView {
    @discardableResult func saveImage(image: UIImage, plant: Plant) async -> (Photo, Snap)? {
        do {
            let photo = try await store.createPhoto(image: image)
            let snap = try await store.createSnap(plant: plant, photo: photo, start: NormalizedCoordinate.start, end: NormalizedCoordinate.end)
            return (photo, snap)
        } catch {
            print("Save photo error \(error)")
            return nil
        }
    }
}
