//
//  SnapsListViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class SnapsListViewModel: ObservableObject {
    @Published var dataSource: [Snap] = []
    @Published var photo: Photo? = nil
    private var cancellables = Set<AnyCancellable>()

    init(photo: Photo) {
        self.photo = photo

//        $photo.compactMap{ $0?.snaps }
//            .assign(to: \.dataSource, on: self)
//            .store(in: &cancellables)
    }
}
