//
//  PhotoRowViewModel.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/20/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//
// https://peterfriese.dev/replicating-reminder-swiftui-firebase-part1/

import Combine
import Foundation

class PhotoRowViewModel: ObservableObject, Identifiable {
    @Published var photo: Photo
    private var cancellables = Set<AnyCancellable>()
    
    var id: String?
    @Published var url: URL = URL(string: "www.google.com")!
    var textString: String = ""
        
    init(photo: Photo) {
        self.photo = photo
        
        // assign id
        $photo
            .map{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        // assign text
        $photo
            .map{ "Taken: \($0.dateString)" }
            .assign(to: \.textString, on: self)
            .store(in: &cancellables)
        
        // assign url
        $photo
            .compactMap{ URL(string: $0.url) }
            .assign(to: \.url, on: self)
            .store(in: &cancellables)
    }
}
