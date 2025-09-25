//
//  ActionButton.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 25/9/25.
//

import SwiftUI

struct ActionButton: View {
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
