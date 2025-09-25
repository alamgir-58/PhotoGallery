//
//  FullScreenView.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 23/9/25.
//

import SwiftUI
import Kingfisher
import UIKit
import Photos

struct FullScreenView: View {
    
    let photo: Photo
    @State private var zoom = ZoomState()
    @State private var sharePayload: SharePayload?
    @State private var isAlertShown = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            KFImage(URL(string: photo.download_url))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFit()
                .scaleEffect(zoom.currentScale)
                .offset(zoom.currentOffset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { zoom.pinchScale = $0 }
                        .onEnded { _ in zoom.endPinch(min: 1, max: 4) }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            guard zoom.currentScale > 1 else { return }
                            zoom.dragOffset = value.translation
                        }
                        .onEnded { _ in zoom.endDrag() }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) { zoom.toggleDoubleTapZoom(inScale: 2.5) }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Photo")
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 24) {
                ActionButton(icon: "square.and.arrow.up", title: "Share") { shareCurrentPhoto() }
                ActionButton(icon: "arrow.down.to.line", title: "Save") { saveCurrentPhoto() }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
        }
        .sheet(item: $sharePayload) { payload in
            ActivityView(activityItems: payload.items)
                .presentationDetents([.medium, .large])
        }
        .alert("Photo", isPresented: $isAlertShown) {
            Button("OK", role: .cancel) {}
        } message: { Text(alertMessage) }
    }
}

// MARK: - Actions
private extension FullScreenView {
    func shareCurrentPhoto() {
        guard let url = URL(string: photo.download_url) else { return }
        ImageLoader.load(from: url) { result in
            Task { @MainActor in
                switch result {
                case .success(let image):
                    sharePayload = SharePayload(items: [image, ImageShareItem(image: image, title: "Photo")])
                case .failure:
                    sharePayload = SharePayload(items: [url])
                }
            }
        }
    }
    
    func saveCurrentPhoto() {
        guard let url = URL(string: photo.download_url) else { return }
        ImageLoader.load(from: url) { result in
            switch result {
            case .success(let image):
                PhotoSaver.save(image) { saveResult in
                    Task { @MainActor in
                        switch saveResult {
                        case .success: alertMessage = "Saved to Photos ✅"
                        case .failure(let error): alertMessage = "Failed to save: \(error.localizedDescription)"
                        }
                        isAlertShown = true
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
