// https://developer.apple.com/tutorials/sample-apps/imagegallery

import SwiftUI

struct PhotoGalleryView<T>: View where T: Store {
    @State private var isAddingPhoto = false

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var numColumns = 3

    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }

    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(store.allPhotos) { photo in
                        GeometryReader { geo in
                            NavigationLink(destination: PhotoDetailView(photo: photo, store: store)
                            ) {
                                GridItemView(size: geo.size.width, item: photo)
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
}
