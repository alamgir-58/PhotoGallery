//
//  ImageLoader.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import UIKit
import Kingfisher

enum ImageLoader {
    static func load(from url: URL, completion: @escaping (Result<UIImage, KingfisherError>) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let v): completion(.success(v.image))
            case .failure(let e): completion(.failure(e))
            }
        }
    }
    
    static func load(from url: URL) async -> Result<UIImage, KingfisherError> {
        await withCheckedContinuation { cont in
            load(from: url) { cont.resume(returning: $0) }
        }
    }
}
