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
//    @EnvironmentObject var overlayEnvironment: OverlayEnvironment

    /// Image picker
    private let image: UIImage
    @State var isSaveButtonEnabled: Bool = false

    @ObservedObject var store: T

    private let plant: Plant

    private let imageSize = CGSize(width: UIScreen.main.bounds.width,
                                   height: UIScreen.main.bounds.width)

    @State var start: CGPoint = .zero
    @State var end: CGPoint = .zero

    private var title: String {
        if TESTING {
            return "AddSnapToPlantView"
        } else {
            return "Add Photo"
        }
    }

    init(store: T, plant: Plant, image: UIImage) {
        self.store = store
        self.plant = plant
        self.image = image

//        overlayEnvironment.isAddingSnap = true
//        overlayEnvironment.image = image
    }

    var body: some View {
        Text(title)
        ZStack {
            SnapEditView(plant: plant,
                         image: image,
                         store: store,
                         imageSize: imageSize,
                         coordinatesChanged: $isSaveButtonEnabled,
                         start: $start,
                         end: $end
            )
        }
//        VStack {
//            Image(uiImage: image)
//                .resizable()
//                .frame(width: UIScreen.main.bounds.width,
//                        height: UIScreen.main.bounds.width)
//                .aspectRatio(contentMode: .fit)
//                .clipped()
//        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton,
                            trailing: saveButton)
//        .alert(isPresented: $viewModel.isShowingError) {
//            Alert(title: Text(viewModel.errorMessage ?? "Unknown error"))
//        }

    }

    private var saveButton: some View {
        Button(action: {
            Task {
                do {
                    try await saveSnap()
                    DispatchQueue.main.async {
                        router.navigateBack()
                    }
                } catch let error {
                    print("Eerror \(error)")
                }
            }
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
}

// MARK: -

// TODO: move this to a common photo class
extension AddSnapToPlantView {
    func saveSnap() async throws {
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: start, end: end)

        let photo = try await store.createPhoto(image: image)
        let snap = try await store.createSnap(plant: plant, photo: photo, start: startCoord, end: endCoord)
    }
}
