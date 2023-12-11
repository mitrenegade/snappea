//
//  TappableView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/6/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//
// Not used, but could potentially be used for more complex views for custom gestures like dragging a box
// https://stackoverflow.com/a/56518293

import SwiftUI

struct TappableView:UIViewRepresentable {
    var tappedCallback: ((CGPoint) -> Void)

    func makeUIView(context: UIViewRepresentableContext<TappableView>) -> UIView {
        let v = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                             action: #selector(Coordinator.tapped))
        v.addGestureRecognizer(gesture)
        return v
    }

    class Coordinator: NSObject {
        var tappedCallback: ((CGPoint) -> Void)
        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
            self.tappedCallback = tappedCallback
        }
        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point)
        }
    }

    func makeCoordinator() -> TappableView.Coordinator {
        return Coordinator(tappedCallback:self.tappedCallback)
    }

    func updateUIView(_ uiView: UIView,
                       context: UIViewRepresentableContext<TappableView>) {
    }

}
