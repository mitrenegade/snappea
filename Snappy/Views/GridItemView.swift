/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GridItemView: View {
    let size: Double
    let item: Photo

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let url = item.url {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: size, height: size)
            } else {
                EmptyView()
            }
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
