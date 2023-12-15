//
//  SnapOverlayView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct SnapOverlayView: View {
    @ObservedObject var viewModel: SnapOverlayViewModel
    var imageSize: CGSize
    
    @State var dragging: Bool = false
    @State var draggingStart: CGPoint = CGPoint.zero
    @State var draggingEnd: CGPoint = CGPoint.zero

    private var apiService: APIService
    var onAddSnap: ((Photo)->Void)?

    init(photo: Photo,
         apiService: APIService = FirebaseAPIService.shared,
         onAddSnap:((Photo)->Void)? = nil) {

        viewModel = SnapOverlayViewModel(photo: photo)
        imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        self.onAddSnap = onAddSnap
        
        self.apiService = apiService
    }
    
    var body: some View {
        ZStack {
            AsyncImageView(url: $viewModel.url.wrappedValue,
                           frame: imageSize,
                           placeholder: Text("Loading..."),
                           cache: TemporaryImageCache.shared)
                .aspectRatio(contentMode: .fill)
            drawBoxView
            ForEach(viewModel.snaps) {snap in
                SnapView(snap: snap)
            }
        }.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged{ (value) in
                    print("Dragging: \(value.startLocation) to \(value.location)")
                    self.dragging = true
                    self.draggingStart = value.startLocation
                    self.draggingEnd = value.location
                }
                .onEnded{ value in
                    self.dragging = false
                    self.draggingStart = CGPoint.zero
                    self.draggingEnd = CGPoint.zero

                    print("Tapped: \(value)")
                    self.createSnap(start: value.startLocation, end: value.location)
                }
        )
    }
    
    func createSnap(start: CGPoint, end: CGPoint) {
        guard let photoId = viewModel.photoId else { return }
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: self.imageSize, start: start, end: end)

        print("createSnap startCoord: \(startCoord) endCoord \(endCoord)")

        let snap = Snap(photoId: photoId, start: startCoord, end: endCoord)

        apiService.addSnap(snap) {_,_ in
            self.onAddSnap?(self.viewModel.photo)
        }
    }
    
    var drawBoxView: some View {
        Group {
            if dragging {
                DragView(imageSize: imageSize, start: draggingStart, end: draggingEnd)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    SnapOverlayView(photo: Stub.photoData[0], apiService: FirebaseAPIService.shared, onAddSnap: nil)
}
