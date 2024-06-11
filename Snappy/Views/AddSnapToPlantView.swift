//
//  AddSnapToPlantView.swift
//  Snappy
//
//  Created by Bobby Ren on 3/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddSnapToPlantView<T>: View where T: Store {
    @EnvironmentObject var router: Router

    /// Image picker
    private let image: UIImage
    @State var isSaveButtonEnabled: Bool = false
    @State var isShowingError: Bool = false
    @State private var error: Error? {
        didSet {
            isShowingError = error == nil
        }
    }
    @State private var shouldShowConfirmation: Bool = false

    @ObservedObject var store: T

    private let plant: Plant

    private let imageSize = CGSize(width: UIScreen.main.bounds.width,
                                   height: UIScreen.main.bounds.width)

    @State var start: CGPoint = .zero
    @State var end: CGPoint = .zero

    private var onSuccess: (() -> Void)?

    private var title: String {
        if TESTING {
            return "AddSnapToPlantView"
        } else {
            return "Add Photo"
        }
    }

    init(store: T, plant: Plant, image: UIImage, onSuccess: (() -> Void)?) {
        self.store = store
        self.plant = plant
        self.image = image
        self.onSuccess = onSuccess
    }

    var body: some View {
        Text(title)
        ZStack {
            SnapEditView(plant: plant,
                         image: image,
                         store: store,
                         coordinatesChanged: $isSaveButtonEnabled,
                         start: $start,
                         end: $end
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton,
                            trailing: saveButton)
        .alert(isPresented: $isShowingError) {
            Alert(title: Text(error?.localizedDescription ?? "Unknown error"))
        }
        .alert(isPresented: $shouldShowConfirmation) {
            Alert(title: Text("Confirm save photo"),
                  message: Text("Are you sure you want to add this snap to \(plant.name)?"),
                  primaryButton: .default(Text("Save"), action: {
                performSave()
                shouldShowConfirmation = false
            }),
                  secondaryButton: .default(Text("Cancel")))
        }
    }

    private var saveButton: some View {
        Button(action: {
            confirmSave()
        }) {
            Text("Save")
        }
        .disabled(!isSaveButtonEnabled)
    }

    private var backButton: some View {
        Button {
            router.navigateBack()
        } label: {
            Image(systemName: "arrow.backward")
        }
    }

    private func confirmSave() {
        shouldShowConfirmation = true
    }

    private func performSave() {
        Task {
            do {
                try await saveSnap()
                onSuccess?()
            } catch let error {
                print("Error \(error)")
                self.error = error
                self.isShowingError = true
            }
        }
    }
}

// MARK: -

// TODO: move this to a common photo class
extension AddSnapToPlantView {
    func saveSnap() async throws {
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: start, end: end)

        let photo = try await store.createPhoto(image: image)
        let _ = try await store.createSnap(plant: plant, photo: photo, start: startCoord, end: endCoord)
    }
}
