//
//  PhotoSaver.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import UIKit
import Photos

enum PhotoSaver {
    static func save(_ image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                completion(.failure(NSError(domain: "PhotoSaver",
                                            code: 1,
                                            userInfo: [NSLocalizedDescriptionKey: "Please allow photo access to save."])))
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if success { completion(.success(())) }
                else { completion(.failure(error ?? NSError(domain: "PhotoSaver", code: 2))) }
            }
        }
    }
}
