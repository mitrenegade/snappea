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
    @ObservedObject var router = Router()

    @State private var showCaptureImageView: Bool = false
//    @State private var cameraSourceType: UIImagePickerController.SourceType = TESTING ? .photoLibrary : .camera
    @State private var cameraSourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?

    private let store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            NavigationView{
                captureImageView
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .addImageToPlant:
                            // no op until plant exists
                            EmptyView()
                        case .createPlantWithImage(let image):
                            // TODO: SelectPlantView
                            EmptyView()
                        }
                    }
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: image) { oldValue, newValue in
                if let newValue {
                    router.navigate(to: .createPlantWithImage(image: newValue))
                }
            }
            .environmentObject(router)
        }
    }

    var captureImageView: some View {
        CaptureImageView(isShown: $showCaptureImageView,
                         image: $image,
                         mode: $cameraSourceType)
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
