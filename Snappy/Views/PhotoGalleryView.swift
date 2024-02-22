// https://developer.apple.com/tutorials/sample-apps/imagegallery

import SwiftUI

struct PhotoGalleryView<T>: View where T: Store {
    @State private var isAddingPhoto = false

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var numColumns = 3

    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }

    private let imageLoaderType: any ImageLoader.Type

    @ObservedObject var store: T

    init(store: T,
         imageLoaderType: any ImageLoader.Type
    ) {
        self.store = store
        self.imageLoaderType = imageLoaderType
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(store.allPhotos) { photo in
                        GeometryReader { geo in
                            NavigationLink(destination: PhotoDetailView(photo: photo, store: store, imageLoaderType: imageLoaderType)
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
        .navigationBarTitle("Image Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isAddingPhoto) {
//            PhotoPicker()
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(isEditing ? "Done" : "Edit") {
//                    withAnimation { isEditing.toggle() }
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    isAddingPhoto = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//                .disabled(isEditing)
//            }
//        }
    }
}
