//
//  MockAPIService.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

struct MockAPIService: APIService {
    func fetchPhotos() async throws -> [Photo] {
        []
    }

    func fetchPlants() async throws -> [Plant] {
        []
    }

    func fetchSnaps() async throws -> [Snap] {
        []
    }

    func loadGarden() async throws {
        // no op
    }
    
    func addSnap(_ snap: Snap, result: @escaping ((Snap?, Error?) -> Void)) {
        // no op
        result(snap, nil)
    }
    
    func addPlant(_ plant: Plant) {
        // no op
    }
    
    func addPhoto(_ photo: Photo, completion: @escaping ((Photo?, Error?) -> Void)) {
        // no op
    }
    
    func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?) -> Void)?) {
        // no op
    }
    
    func uploadTestData() {
        // no op
    }
}
