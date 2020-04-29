//
//  PhotosListViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class PhotosListViewModel: ObservableObject {    // datasource
    @Published var dataSource: [Photo]
    
    init() {
        // TODO: load data, process it if necessary
        let data: [Photo] = DataSample.photoData
        dataSource = data
    }
}
