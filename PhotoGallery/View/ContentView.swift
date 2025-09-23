//
//  ContentView.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 23/9/25.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @StateObject var networkManager = NetworkManager()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(networkManager.photos) { photo in
                        NavigationLink(destination: FullScreenView(photo: photo)) {
                            KFImage(URL(string: photo.download_url))
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
            }
            .navigationTitle("Photo Gallery")
            .onAppear {
                networkManager.fetchPhotos()
            }
        }
    }
}

#Preview {
    ContentView()
}

