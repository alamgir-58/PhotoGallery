//
//  ZoomState.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import CoreGraphics

struct ZoomState {
    var baseScale: CGFloat = 1
    var pinchScale: CGFloat = 1
    var baseOffset: CGSize = .zero
    var dragOffset: CGSize = .zero
    
    var currentScale: CGFloat { baseScale * pinchScale }
    var currentOffset: CGSize {
        .init(width: baseOffset.width + dragOffset.width,
              height: baseOffset.height + dragOffset.height)
    }
    
    mutating func endPinch(min: CGFloat = 1, max: CGFloat = 4) {
        baseScale = (baseScale * pinchScale).clamped(min...max)
        pinchScale = 1
        if baseScale == 1 { baseOffset = .zero }
    }
    
    mutating func endDrag() {
        baseOffset.width += dragOffset.width
        baseOffset.height += dragOffset.height
        dragOffset = .zero
    }
    
    mutating func toggleDoubleTapZoom(inScale: CGFloat = 2.5) {
        if baseScale > 1 {
            baseScale = 1
            baseOffset = .zero
        } else {
            baseScale = inScale
        }
    }
}
