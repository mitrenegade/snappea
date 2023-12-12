//
//  PlantsListViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class PlantsListViewModel: ObservableObject {
    @Published var dataSource: [Plant] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var router: HomeViewRouter

    init(apiService: APIService, router: HomeViewRouter) {
        self.router = router

        apiService.$plants
            .assign(to: \.dataSource, on: self)
            .store(in: &cancellables)
    }
}
