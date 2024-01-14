// https://developer.apple.com/tutorials/sample-apps/imagegallery

import SwiftUI

struct PhotoGalleryView: View {
    @EnvironmentObject var viewModel: PhotoGalleryViewModel

    private static let initialColumns = 3
    @State private var isAddingPhoto = false

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State private var numColumns = initialColumns

    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }

    private let apiService: APIService
    private let store: Store

    init(apiService: APIService, store: Store) {
        self.apiService = apiService
        self.store = store
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(viewModel.dataSource) { photo in
                        GeometryReader { geo in
                            NavigationLink(destination: PhotoDetailView(photo: photo, store: store, apiService: apiService)
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
