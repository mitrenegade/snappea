//
//  ImageStore.swift
//  Snappy
//
//  Created by Bobby Ren on 4/25/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

/// Persists images
final class ImageStore {
    enum ImageStoreError: Error {
        case documentsDirectoryError
        case readFailure
        case writeFailure
    }

    func loadImage(name: String) throws -> UIImage {
        let url = URL.documentsDirectory.appending(path: "image").appending(path: name)
        if let imageData = try? Data(contentsOf: url),
           let image = UIImage(data: imageData) {
            return image
        } else {
            throw ImageStoreError.readFailure
        }
    }

    func saveImage(_ image: UIImage, name: String) throws {
        let url = URL.documentsDirectory.appending(path: "image").appending(path: name)
        
        guard let data = image.pngData() else {
            throw ImageStoreError.writeFailure
        }
        try data.write(to: url, options: [.atomic, .completeFileProtection])
    }
}
