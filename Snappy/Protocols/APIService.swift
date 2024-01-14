//
//  APIService.swift
//  Snappy
//
//  Created by Bobby Ren on 4/29/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

protocol APIService {
    /// Fetch data
    func loadGarden() async throws
    func fetchPhotos() async throws -> [Photo]
    func fetchPlants() async throws -> [Plant]
    func fetchSnaps() async throws -> [Snap]

    /// Create data
    func addSnap(_ snap: Snap, result: @escaping ((Snap?, Error?)->Void))
    func addPlant(_ plant: Plant)
    func addPhoto(_ photo: Photo, completion: @escaping ((Photo?, Error?)->Void))
    func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)?)

    /// Testing/misc
    func uploadTestData()
}
