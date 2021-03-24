//
//  EventError.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/17/21.
//

import Foundation

enum EventError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case unableToFavorite
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The server failed to reach the given URL"
        case .thrownError(let error):
            return "Oops, there was an error: \(error.localizedDescription)"
        case .noData:
            return "The server failed to provide the data"
        case .unableToDecode:
            return "There was an error trying to decode data"
        case .unableToFavorite:
            return "There was an error favoriting this user. Please try again."
        }
    }
}
