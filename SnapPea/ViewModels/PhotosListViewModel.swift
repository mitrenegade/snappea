//
//  PhotosListViewModel.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class PhotosListViewModel: ObservableObject {
    @Published var dataSource: [Photo] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var shouldShowNewPhotoDetail: Photo? {
        didSet {
            print("shouldShowNewPhotoDetail: \(shouldShowNewPhotoDetail != nil)")
        }
    }
    @Published var router: HomeViewRouter

    init(apiService: APIService, router: HomeViewRouter) {
        self.router = router

        apiService.$photos
            .assign(to: \.dataSource, on: self)
            .store(in: &cancellables)
        
        $router
            .map{ $0.newPhoto }
            .assign(to: \.shouldShowNewPhotoDetail, on: self)
            .store(in: &cancellables)
    }
}
