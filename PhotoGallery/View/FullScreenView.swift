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
import Photos

struct SharePayload: Identifiable {
    let id = UUID()
    let items: [Any]
}

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

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    var excludedActivityTypes: [UIActivity.ActivityType] = []
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        vc.excludedActivityTypes = excludedActivityTypes
        return vc
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct FullScreenView: View {
    let photo: Photo
    
    @State private var baseScale: CGFloat = 1
    @State private var pinchScale: CGFloat = 1
    @State private var baseOffset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    
    @State private var sharePayload: SharePayload?
    
    @State private var isAlertShown = false
    @State private var alertMessage = ""
    
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
                            if baseScale == 1 { baseOffset = .zero }
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
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 24) {
                ActionButton(icon: "square.and.arrow.up", title: "Share") {
                    shareCurrentPhoto()
                }
                ActionButton(icon: "arrow.down.to.line", title: "Save") {
                    saveCurrentPhoto()
                }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
        }
        .sheet(item: $sharePayload) { payload in
            ActivityView(activityItems: payload.items)
                .presentationDetents([.medium, .large]) // optional
        }
        .alert("Photo", isPresented: $isAlertShown) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
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
                    sharePayload = SharePayload(items: [
                        value.image,
                        ImageShareItem(image: value.image, title: "Photo")
                    ])
                case .failure:
                    sharePayload = SharePayload(items: [url])
                }
            }
        }
    }
    
    private func saveCurrentPhoto() {
        guard let url = URL(string: photo.download_url) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let image = value.image
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    guard status == .authorized || status == .limited else {
                        Task { @MainActor in
                            alertMessage = "Please allow photo access to save."
                            isAlertShown = true
                        }
                        return
                    }
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        Task { @MainActor in
                            if success {
                                alertMessage = "Saved to Photos ✅"
                            } else {
                                alertMessage = "Failed to save: \(error?.localizedDescription ?? "Unknown error")"
                            }
                            isAlertShown = true
                        }
                    }
                }
                
            case .failure(let err):
                Task { @MainActor in
                    alertMessage = "Couldn't load image: \(err.localizedDescription)"
                    isAlertShown = true
                }
            }
        }
    }
}

private struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                Text(title)
                    .font(.footnote)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(title))
    }
}
