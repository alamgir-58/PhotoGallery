//
//  FullScreenView.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 23/9/25.
//

import SwiftUI
import Kingfisher
import UIKit
import LinkPresentation

final class ImageShareItem: NSObject, UIActivityItemSource {
    let image: UIImage
    init(image: UIImage) { self.image = image }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? { image
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = "Photo"
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct FullScreenView: View {
    let photo: Photo
    
    @State private var baseScale: CGFloat = 1
    @State private var pinchScale: CGFloat = 1
    @State private var baseOffset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    
    @State private var isSharePresented = false
    @State private var shareItems: [Any] = []
    
    var body: some View {
        ZStack {
            KFImage(URL(string: photo.download_url))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFit()
                .scaleEffect(baseScale * pinchScale)
                .offset(
                    x: baseOffset.width + dragOffset.width,
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    shareCurrentPhoto()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isSharePresented) {
            ActivityView(activityItems: shareItems)
        }
    }
    
    private func clamp(_ v: CGFloat, _ minV: CGFloat, _ maxV: CGFloat) -> CGFloat {
        Swift.min(Swift.max(v, minV), maxV)
    }
    
    private func shareCurrentPhoto() {
        guard let url = URL(string: photo.download_url) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            Task { @MainActor in
                switch result {
                case .success(let value):
                    shareItems = [ImageShareItem(image: value.image)]
                    isSharePresented = true
                case .failure:
                    shareItems = [url]
                    isSharePresented = true
                }
            }
        }
    }
}
