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
    
    @State private var baseScale: CGFloat = 1
    @State private var pinchScale: CGFloat = 1
    @State private var baseOffset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            KFImage(URL(string: photo.download_url))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFit()
                .scaleEffect(baseScale * pinchScale)
                .offset(x: baseOffset.width + dragOffset.width,
                        y: baseOffset.height + dragOffset.height
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { pinchScale = $0 }
                        .onEnded { _ in
                            baseScale = clamp(baseScale * pinchScale, 1, 4)
                            pinchScale = 1
                            if baseScale == 1 {
                                baseOffset = .zero
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            guard baseScale * pinchScale > 1 else { return }
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            baseOffset.width += dragOffset.width
                            baseOffset.height += dragOffset.height
                            dragOffset = .zero
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        if baseScale > 1 {
                            baseScale = 1
                            baseOffset = .zero
                        } else {
                            baseScale = 2.5
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Photo")
    }
    
    private func clamp(_ v: CGFloat, _ minV: CGFloat, _ maxV: CGFloat) -> CGFloat {
        Swift.min(Swift.max(v, minV), maxV)
    }
}
