//
//  Favorite.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/22/21.
//

import Foundation

class Favorite: Codable {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}

extension Favorite: Equatable {
    static func ==(lhs: Favorite, rhs: Favorite) -> Bool {
        return lhs.id == rhs.id
    }
}
