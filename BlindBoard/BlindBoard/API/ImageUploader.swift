//
//  ImageUploader.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/09/28.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    
    static func imageUpload(image: UIImage, completion: @escaping([String]) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return }
        print("IMAGEDATA: \(imageData.description)")
        let fileName = NSUUID().uuidString
        print("FILENAME: \(fileName)")
        let ref = Storage.storage().reference(withPath: "/\(SceneDelegate.uid ?? "error")/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { metaData, error in
            if error != nil {
                print("FAIL TO UPLOAD")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return print("IMAGEURL ERROR") }
                print(imageUrl)
                completion([imageUrl, fileName])
            }
        }
        
    }
}
