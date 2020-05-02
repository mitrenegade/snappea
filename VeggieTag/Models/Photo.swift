//
//  Photo.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore

struct Photo: Identifiable, Hashable, Codable {

    var id: String
    var url: String
    var timestamp: TimeInterval
    
    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    var dateString: String {
        return date.description
    }
    
    init?(from snapshot: QueryDocumentSnapshot) {
        guard let url = snapshot["name"] as? String else { return nil }

        self.id = snapshot.documentID
        self.url = url
        self.timestamp = snapshot["timestamp"] as? TimeInterval ?? 0
    }
}
