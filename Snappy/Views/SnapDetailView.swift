//
//  SnapDetailView.swift
//  Snappy
//
//  Created by Bobby Ren on 1/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Displays a single snap on a photo with options to edit
struct SnapDetailView<T>: View where T: Store {
    @EnvironmentObject var router: Router
    @ObservedObject var store: T

    private let snap: Snap

    private let photo: Photo

    private var plant: Plant?

    private let imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)

    @State var start: CGPoint = .zero
    @State var end: CGPoint = .zero

    @State var isSaveButtonEnabled: Bool = false
    @State var isShowingError: Bool = false
    @State private var error: Error? {
        didSet {
            isShowingError = error == nil
        }
    }

    var title: String {
        "SnapDetailView: \(snap.id)"
    }

    var body: some View {
        if TESTING {
            Text(title)
        }
        VStack {
            imageSection
            infoSection
            Spacer()
        }
        .navigationBarItems(trailing: saveButton)
        .alert(isPresented: $isShowingError) {
            Alert(title: Text(error?.localizedDescription ?? "Unknown error"))
        }
    }

    /// Creates a PhotoDetailView
    /// Given a snap, shows the photo for only the snap
    init?(snap: Snap, 
          store: T,
          environment: OverlayEnvironment
    ) {
        guard let photo = store.photo(withId: snap.photoId) else {
            return nil
        }
        self.photo = photo
        self.snap = snap
        self.store = store

        self.plant = store.plant(withId: snap.plantId)

        // modifying environment on it is required to clear existing snap information
        environment.isEditingSnap = false
        environment.snap = snap
    }

    var imageSection: some View {
        SnapEditView(snap: snap,
                     store: store,
                     coordinatesChanged: $isSaveButtonEnabled,
                     start: $start,
                     end: $end)
    }

    var infoSection: some View {
        VStack {
            Text("Snap \(snap.id)")
            Text("Plant: \(plant?.id ?? "none")")
        }
    }

    private var saveButton: some View {
        Button(action: {
            Task {
                do {
                    try await updateSnap()
                    DispatchQueue.main.async {
                        router.navigateBack()
                    }
                } catch let error {
                    print("Error \(error)")
                    self.error = error
                    self.isShowingError = true
                }
            }
        }) {
            Text("Save")
        }
        .disabled(!isSaveButtonEnabled)
    }
}

// TODO: move this to a common photo class
extension SnapDetailView {
    func updateSnap() async throws {
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: start, end: end)

        let _ = try await store.updateSnap(snap: snap, photoId: nil, start: startCoord, end: endCoord)
    }
}
