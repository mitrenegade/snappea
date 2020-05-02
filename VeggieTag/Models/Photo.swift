//
//  Photo.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Photo: Identifiable, Codable {

    @DocumentID var id: String?
    
    var url: String
    var timestamp: TimeInterval
    @ServerTimestamp var createdTime: Timestamp?

    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    var dateString: String {
        return date.description
    }
}
