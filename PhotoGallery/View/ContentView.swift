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
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(networkManager.photos) { photo in
                            NavigationLink(destination: FullScreenView(photo: photo)) {
                                KFImage(URL(string: photo.download_url))
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 3 - 12,
                                           height: geometry.size.width / 3 - 12
                                    )
                                    .clipped()
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Photos")
            .onAppear {
                networkManager.fetchPhotos()
            }
        }
    }
}

#Preview {
    ContentView()
}
