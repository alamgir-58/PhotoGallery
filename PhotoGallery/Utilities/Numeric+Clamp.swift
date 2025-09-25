//
//  Numeric+Clamp.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import CoreGraphics

extension Comparable {
    func clamped(_ limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension CGFloat {
    func clamped(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        Swift.min(Swift.max(self, min), max)
    }
}
