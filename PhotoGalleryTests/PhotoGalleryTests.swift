//
//  PhotoGalleryTests.swift
//  PhotoGalleryTests
//
//  Created by Alamgir Hossain on 23/9/25.
//

import XCTest
@testable import PhotoGallery

final class ZoomStateTests: XCTestCase {

    func testCurrentScaleAndOffset() {
        var zoom = ZoomState()
        zoom.baseScale = 2
        zoom.pinchScale = 1.5
        zoom.baseOffset = CGSize(width: 10, height: -5)
        zoom.dragOffset = CGSize(width: 3, height: 7)

        XCTAssertEqual(zoom.currentScale, 3.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.currentOffset.width, 13.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.currentOffset.height, 2.0, accuracy: CGFloat(0.0001))
    }

    func testEndPinchClampsToMaxAndResetsPinch() {
        var zoom = ZoomState()
        zoom.baseScale = 2
        zoom.pinchScale = 3
        zoom.endPinch(min: 1, max: 4)

        XCTAssertEqual(zoom.baseScale, 4.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.pinchScale, 1.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.baseOffset, .zero)
    }

    func testEndPinchClampsToMinAndResetsOffsetWhenBackToOne() {
        var zoom = ZoomState()
        zoom.baseScale = 2
        zoom.baseOffset = CGSize(width: 50, height: -40)
        zoom.pinchScale = 0.3

        zoom.endPinch(min: 1, max: 4)

        XCTAssertEqual(zoom.baseScale, 1.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.pinchScale, 1.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.baseOffset, .zero)
    }

    func testEndDragAccumulatesAndClearsDragOffset() {
        var zoom = ZoomState()
        zoom.baseOffset = CGSize(width: 10, height: 20)
        zoom.dragOffset = CGSize(width: -3, height: 5)

        zoom.endDrag()

        XCTAssertEqual(zoom.baseOffset.width, 7.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.baseOffset.height, 25.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.dragOffset, .zero)
    }

    func testToggleDoubleTapZoomInAndOut() {
        var zoom = ZoomState()
        XCTAssertEqual(zoom.baseScale, 1.0, accuracy: CGFloat(0.0001))

        zoom.toggleDoubleTapZoom(inScale: 2.5)
        XCTAssertEqual(zoom.baseScale, 2.5, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.baseOffset, .zero)

        zoom.baseOffset = CGSize(width: 30, height: -10)

        zoom.toggleDoubleTapZoom(inScale: 2.5)
        XCTAssertEqual(zoom.baseScale, 1.0, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.baseOffset, .zero)
    }

    func testEndPinchWithinRange() {
        var zoom = ZoomState()
        zoom.baseScale = 1.2
        zoom.pinchScale = 1.3

        zoom.endPinch()

        XCTAssertEqual(zoom.baseScale, 1.56, accuracy: CGFloat(0.0001))
        XCTAssertEqual(zoom.pinchScale, 1.0, accuracy: CGFloat(0.0001))
    }
}
