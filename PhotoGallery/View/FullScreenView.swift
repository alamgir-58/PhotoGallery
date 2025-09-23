//
//  FullScreenView.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 23/9/25.
//

import SwiftUI
import Kingfisher

struct FullScreenView: View {
    
    let photo: Photo
    
    var body: some View {
        ZStack {
            KFImage(URL(string: photo.download_url))
                .placeholder { ProgressView() }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Photo")
    }
}
