//
//  FirebaseImageService.swift
//  Snappy
//
//  Created by Bobby Ren on 5/13/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseCore
import FirebaseStorage

fileprivate let storage = Storage.storage()
fileprivate let storageRef = storage.reference()
fileprivate let imageBaseRef = storageRef.child(StoreObject.image.rawValue)

public class FirebaseImageService: NSObject {
    
    public enum ImageType: String {
        case photo
    }
    
    fileprivate class func referenceForImage(type: ImageType, id: String) -> StorageReference? {
        imageBaseRef.child(type.rawValue).child(id)
    }
    
    public class func uploadImage(image: UIImage, type: ImageType, uid: String, progressHandler: ((_ percent: Double)->Void)? = nil, completion: @escaping ((_ imageUrl: String?)->Void)) {
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
            imageRef.downloadURL(completion: { (url, error) in
                completion(url?.absoluteString)
            })
        }
        
        uploadTask.observe(.progress) { (storageTaskSnapshot) in
            if let progress = storageTaskSnapshot.progress {
                print("Progress \(progress)")
                let percent = progress.fractionCompleted
                progressHandler?(percent)
            }
        }
    }
    
    public class func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
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
        let ref = FirebaseImageService.referenceForImage(type: .photo, id: id)
        ref?.downloadURL(completion: { (url, error) in
            if let url = url {
                completion(url)
            } else {
                completion(nil)
            }
        })
    }
}
