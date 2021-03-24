//
//  FavoriteController.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/22/21.
//

import Foundation

class FavoriteController {
    
    // MARK: - Singleton
    static let shared = FavoriteController()
    
    // MARK: - Source of Truth
    var favorites: [Favorite] = []
    
    // MARK: - CRUD
    func addFavorite(from eventID: Int) {
        let event = Favorite(id: eventID)
        favorites.append(event)
        saveFileToPersistentStore()
    }
    
    func removeFavorite(eventID: Int) {
        var pointer = 0
        
        while pointer < (favorites.count) {
            let scanner = favorites[pointer]
            if scanner.id == eventID {
                favorites.remove(at: pointer)
                saveFileToPersistentStore()
                return
            }
            pointer += 1
        }
    }
    
    // MARK: - Persistence
    func createFileForPersistence() -> URL{
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("Favorites.json")
        return fileURL
    }
    
    func saveFileToPersistentStore() {
        
        // Create JSON Encoder
        let jsonEncoder = JSONEncoder()
        
        do {
            // Creates a constant that accesses JSONEncoder to encode the Source of Truth in JSON
            let data = try jsonEncoder.encode(favorites)
            
            // Writes the JSON file to local storage
            try data.write(to: createFileForPersistence())
        } catch {
            
            // If saving fails, prints an error where the issue occured
            print("There is an error encoding data \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            // Searches for contents of the file
            let data = try Data(contentsOf: createFileForPersistence())
            
            // Decodes the data
            let decodesFavorites = try jsonDecoder.decode([Favorite].self, from: data)
            
            // Adds the decoded info
            favorites = decodesFavorites
        } catch {
            
            // print an error if one occurs
            print("Unable to load favorites")
        }
    }
}





