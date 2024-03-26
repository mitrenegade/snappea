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
    private let image: UIImage
    @State var isSaveButtonEnabled: Bool = false

    @ObservedObject var store: T

    private let plant: Plant

    private var title: String {
        if TESTING {
            return "AddPhotoToPlantView"
        } else {
            return "Add Photo"
        }
    }

    init(store: T, plant: Plant, image: UIImage) {
        self.store = store
        self.plant = plant
        self.image = image
    }

    var body: some View {
        Text(title)
        VStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.width)
                .aspectRatio(contentMode: .fit)
                .clipped()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                saveButton
            }
        }
//        .navigationBarItems(trailing: saveButton)
//        .alert(isPresented: $viewModel.isShowingError) {
//            Alert(title: Text(viewModel.errorMessage ?? "Unknown error"))
//        }

    }

    private var saveButton: some View {
        Button(action: {
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
