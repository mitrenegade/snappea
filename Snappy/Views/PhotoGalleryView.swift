// https://developer.apple.com/tutorials/sample-apps/imagegallery

import SwiftUI

struct PhotoGalleryView<T>: View where T: Store {
    @EnvironmentObject var photoEnvironment: PhotoEnvironment

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var numColumns = 3

    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }

    @ObservedObject var store: T
    // If using PhotoGalleryView to add a plant
    // TODO: make this a AddPhotoFromGalleryView
    let shouldShowDetail: Bool
    @Binding var shouldShowGallery: Bool

//    init(store: T, shouldShowDetail: Bool = false) {
//        self.store = store
//        self.shouldShowDetail = shouldShowDetail
//    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(store.allPhotos) { photo in
                        GeometryReader { geo in
                            // the GridItem shows a detail view of the item when clicked
                            if shouldShowDetail {
                                NavigationLink(destination: PhotoDetailView(photo: photo, store: store)
                                ) {
                                    GridItemView(size: geo.size.width, item: photo)
                                }
                            } else {
                                // Selects photo and sets it in PhotoEnvironment
                                Button {
                                    didSelectPhoto(photo)
                                } label: {
                                    GridItemView(size: geo.size.width, item: photo)
                                }
                            }
                        }
                        .cornerRadius(8.0)
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding()
            }
        }
    }

    private func didSelectPhoto(_ photo: Photo) {
        photoEnvironment.newPhoto = photo
        shouldShowGallery = false
    }
}
