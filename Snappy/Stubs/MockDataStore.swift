//
//  MockDataStore.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

class MockDataStore: DataStore {
    func fetchPhotos() async throws -> [Photo] {
        return Stub.photoData
    }
    
    func fetchPlants() async throws -> [Plant] {
        return Stub.plantData
    }
    
    func fetchSnaps() async throws -> [Tag] {
        return Stub.snapData
    }
}
