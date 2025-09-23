//
//  NetworkManager.swift
//  PhotoGallery
//
//  Created by Alamgir Hossain on 23/9/25.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    
    @Published var photos = [Photo]()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPhotos() {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=52") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] photos in
                self?.photos = photos
            })
            .store(in: &cancellables)
    }
}

