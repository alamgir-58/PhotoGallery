//
//  Photo.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 23/9/25.
//

import Foundation

struct Photo: Identifiable, Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
