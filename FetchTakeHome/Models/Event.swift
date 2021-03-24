//
//  Event.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/17/21.
//

import Foundation

struct Results: Codable {
    let events: [Event]
}

struct Event: Codable {
    let id: Int
    let title: String
    let performers: [Performer]
    let dateTime: String
    let venue: Venue
    var favorite: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "short_title"
        case performers
        case dateTime = "datetime_local"
        case venue
        case favorite
    }
}

// MARL: - Performer object for event image
struct Performer: Codable {
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case image
    }
}

// MARK: - Location object for event location
struct Venue: Codable {
    let displayLocation: String
    
    private enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}
