//
//  PersistenceManager.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/22/21.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys { static let favorites = "favorites" }
    
    static func updateWith(favotite: Event, actionType: PersistenceActionType, completion: @escaping (EventError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    favorites.append(favotite)
                    
                case .remove:
                    favorites.removeAll { $0.id == favotite.id}
                }
                
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Event], EventError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Event].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Event]) -> EventError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
