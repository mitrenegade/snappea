//
//  FirebaseImageService.swift
//  Snappy
//
//  Created by Bobby Ren on 5/13/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseCore
import FirebaseStorage
import SwiftUI

fileprivate let storage = Storage.storage()
fileprivate let storageRef = storage.reference()

public enum ImageType: String {
    case photo
}

protocol ImageService {

    func uploadImage(image: UIImage, type: ImageType, uid: String, progressHandler: ((_ percent: Double)->Void)?, completion: @escaping ((_ imageUrl: String?)->Void))

    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage?

    func photoUrl(with id: String?, completion: @escaping ((URL?)->Void))

}

public class FirebaseImageService: ImageService {

    private let imageBaseRef: StorageReference = storageRef.child(StoreObject.image.rawValue)

    /// - Parameters:
    ///     - type: the `ImageType` which determines if the image is for a Photo, or another object like user
    /// - Returns:
    ///     - a Firebase reference like "gs://firebasestorage.googleapis.com/v0/b/snappy-3b045.appspot.com/o/image/photo"
    fileprivate func referenceForImage(type: ImageType, id: String) -> StorageReference? {
        imageBaseRef.child(type.rawValue).child(id)
    }
    
    public func uploadImage(image: UIImage, type: ImageType, uid: String, progressHandler: ((_ percent: Double)->Void)? = nil, completion: @escaping ((_ imageUrl: String?)->Void)) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            completion(nil)
            return
        }
        guard let imageRef = referenceForImage(type: type, id: uid) else {
            completion(nil)
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let uploadTask = imageRef.putData(data, metadata: metadata) { meta, error in
            if error != nil {
                completion(nil)
                return
            }
            imageRef.downloadURL(completion: { result in
                switch result {
                case .success(let url):
                    completion(url.absoluteString)
                case .failure(let error):
                    print("FirebaseImageService: Fetch URL error \(error)")
                    completion(nil)
                }
            })
        }
        
        uploadTask.observe(.progress) { (storageTaskSnapshot) in
            if let progress = storageTaskSnapshot.progress {
                print("FirebaseImageService: Progress \(progress)")
                let percent = progress.fractionCompleted
                progressHandler?(percent)
            }
        }
    }
    
    public func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
        guard image.size != newSize else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    public func photoUrl(with id: String?, completion: @escaping ((URL?)->Void)) {
        guard let id = id else {
            completion(nil)
            return
        }
        let ref = referenceForImage(type: .photo, id: id)
        ref?.downloadURL(completion: { (url, error) in
            if let url = url {
                completion(url)
            } else {
                completion(nil)
            }
        })
    }
}

class FirebaseImageLoader: ImageLoader, ObservableObject {

    private let imageService = FirebaseImageService()
    private let imageName: String

    @Published var image: UIImage?
    var imageValue: Published<UIImage?> {
        return _image
    }
    var imagePublisher: Published<UIImage?>.Publisher {
        return $image
    }

    required init(imageName: String, baseUrl: URL?, cache: ImageCache?) {
        self.imageName = imageName
    }

    func load() {
        imageService.referenceForImage(type: .photo, id: imageName)?.getData(maxSize: .max) { data, error in
            print("\(data), \(error)")
            if let data {
                self.image = UIImage(data: data)
            }
        }
    }

    func cancel() {
        // no op
    }
}
