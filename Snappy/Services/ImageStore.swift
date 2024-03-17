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

/// Persists images locally
final class ImageStore {
    enum ImageStoreError: Error {
        case documentsDirectoryError
        case readFailure
        case writeFailure
    }

    private let baseURL: URL

    init(baseURL: URL?) {
        self.baseURL = baseURL ?? URL.documentsDirectory
    }

    func loadImage(name: String) throws -> UIImage {
        let url = baseURL.appending(path: name)
        if let imageData = try? Data(contentsOf: url),
           let image = UIImage(data: imageData) {
            print("BRDEBUG -> load success for url \(url)")
            return image
        } else {
            print("BRDEBUG -> load failure for url \(url)")
            throw ImageStoreError.readFailure
        }
    }

    @discardableResult func saveImage(_ image: UIImage, name: String) throws -> URL {
        let url = baseURL.appending(path: name)
        print("BRDEBUG \(self) saveImage name \(name) url \(url)")

        guard let data = image.pngData() else {
            throw ImageStoreError.writeFailure
        }
        try data.write(to: url, options: [.atomic, .completeFileProtection])
        return url
    }
}
