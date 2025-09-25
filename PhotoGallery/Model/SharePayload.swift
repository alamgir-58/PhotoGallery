//
//  SharePayload.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import Foundation

struct SharePayload: Identifiable {
    let id = UUID()
    let items: [Any]
}
