/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GridItemView: View {
    let size: Double
    let item: Photo

    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory

    var body: some View {
        ZStack(alignment: .topTrailing) {
//            let imageLoader = imageLoaderFactory.create(imageName: item.id, cache: TemporaryImageCache.shared)
            let placeholder = Text("Loading...")
            let imageLoader = FirebaseImageLoader()
            AsyncImageView(imageLoader: imageLoader, frame: CGSize(width: size, height: size), placeholder: placeholder)
                .aspectRatio(contentMode: .fill)
        }
    }
}

//struct GridItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        if let url = Bundle.main.url(forResource: "mushy1", withExtension: "jpg") {
//            GridItemView(size: 50, item: Item(url: url))
//        }
//    }
//}
