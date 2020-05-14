//
//  CameraRoot.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CameraRoot: View {
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    @State private var showingSheet = false
    @State var cameraSourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.showingSheet.toggle()
//                    self.showCaptureImageView.toggle()
                }) {
                    Text("Add photo")
                }
                .actionSheet(isPresented: $showingSheet) { () -> ActionSheet in
                    ActionSheet(title: Text("ABCDE"),
                                message: Text("Try this stuff"),
                                buttons:[
                        .default(Text("Cancel")),
                        .default(Text("Photo Album"), action: {
                            // photo album
                            // camera
                            self.cameraSourceType = .photoLibrary
                            self.showCaptureImageView.toggle()
                        }),
                        .default(Text("Camera"), action: {
                            // camera
                            self.cameraSourceType = .camera
                            self.showCaptureImageView.toggle()
                        })
                    ])
                }
//                .image?.resizable()
//                .frame(width: 250, height: 250)
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                    .shadow(radius: 10)
            }
            if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, image: $image, mode: $cameraSourceType)
            }
        }
    }
}

struct CameraRoot_Previews: PreviewProvider {
    static var previews: some View {
        CameraRoot()
    }
}
