//
//  NetworkManager.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/17/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = URL(string: "https://api.seatgeek.com/2/events")
    private let searchQuery = "q"
    private let clientID = "client_id"
    private let clientIDValue = "MjE2MDIxNjV8MTYxNTg1NzMzMC43ODUxNTcy"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func fetchEvents(searchTerm: String, completion: @escaping (Result<[Event], EventError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let eventSearchQuery = URLQueryItem(name: searchQuery, value: searchTerm)
        let clientIDQuery = URLQueryItem(name: clientID, value: clientIDValue)
        
        urlComponents?.queryItems = [eventSearchQuery, clientIDQuery]
        
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let decoder = try JSONDecoder().decode(Results.self, from: data)
                let events = decoder.events
                return completion(.success(events))
            } catch {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }
        .resume()
    }
    
    func fetchImageFor(event: Event, completion: @escaping (Result<UIImage?, EventError>) -> Void) {
        
        guard let url = URL(string: event.performers.first!.image) else  { return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(image))
        } .resume()
    }
}


