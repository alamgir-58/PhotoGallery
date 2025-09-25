//
//  ImageShareItem.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import UIKit
import LinkPresentation

final class ImageShareItem: NSObject, UIActivityItemSource {
    let image: UIImage
    let title: String
    init(image: UIImage, title: String = "Photo") {
        self.image = image
        self.title = title
    }
    func activityViewControllerPlaceholderItem(_ vc: UIActivityViewController) -> Any { image }
    func activityViewController(_ vc: UIActivityViewController,
                                itemForActivityType type: UIActivity.ActivityType?) -> Any? { image }
    func activityViewControllerLinkMetadata(_ vc: UIActivityViewController) -> LPLinkMetadata? {
        let meta = LPLinkMetadata()
        meta.title = title
        meta.imageProvider = NSItemProvider(object: image)
        return meta
    }
}
