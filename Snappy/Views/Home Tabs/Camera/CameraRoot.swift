//
//  CameraRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CameraRoot<T>: View where T: Store {

    @EnvironmentObject var photoEnvironment: PhotoEnvironment
    @EnvironmentObject var tabsRouter: TabsRouter
    @EnvironmentObject var overlayEnvironment: OverlayEnvironment

    @ObservedObject var router = Router()

    // not used
    @State private var showCaptureImageView: Bool = false

    @State private var cameraSourceType: UIImagePickerController.SourceType = TESTING ? .photoLibrary : .camera
//    @State private var cameraSourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @State private var selectedPlant: Plant? = nil

    @State private var didCancel: Bool = false

    private let store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                Group {
                    captureImageView
                }
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .addImageToPlant(let image, let plant):
                        // no op until plant exists
                        AddSnapToPlantView(store: store, plant: plant, image: image) {
                            // reset camera stack
                            router.navigateHome()
                            // return to plant gallery
                            tabsRouter.selectedTab = .plants
                        }
                    case .selectPlantForImage(let image):
                        selectPlantView(image)
                    case .plantGallery:
                        // no plant gallery
                        EmptyView()
                    }
                }
            }
            .onChange(of: image) { oldValue, newValue in
                if let newValue {
                    router.navigate(to: .selectPlantForImage(newValue))
                }
                image = nil
                // now to clear selection in imagePicker
            }
            .onChange(of: didCancel) { oldValue, newValue in
                if newValue {
                    tabsRouter.selectedTab = .plants
                }
                didCancel = false
            }
            .environmentObject(router)
        }
    }

    var captureImageView: some View {
        CaptureImageView(isShown: $showCaptureImageView,
                         image: $image,
                         mode: $cameraSourceType,
                         didCancel: $didCancel)
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
    
    func selectPlantView(_ newImage: UIImage) -> some View {
        VStack {
            if TESTING {
                Text("CameraRoot - SelectPlantView")
            }
            Text("Select an existing plant to add the photo")
            addNewPlantButton
            PlantsListView(store: store, selectedPlant: $selectedPlant)
                .onChange(of: selectedPlant) { oldValue, newValue in
                    if let newPlant = newValue {
                        // Add the new image to an existing plant
                        router.navigate(to: .addImageToPlant(image: newImage, plant: newPlant))
                    }
                    selectedPlant = nil
                }
        }
    }

    var addNewPlantButton: some View {
        Button {
            print("Create new plant")
        } label: {
            Text("- Or create new plant from photo -")
        }
    }

    @MainActor
    func displayNewPhotoDetail(photo: Photo) {
        self.tabsRouter.selectedTab = .gallery
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
