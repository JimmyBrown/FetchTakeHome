//
//  DateFormatter.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/18/21.
//

import Foundation

var event: Event?

class EventDateFormatter {
    
    func dateFormatter(apiDateTime: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateTime = dateFormatter.date(from: apiDateTime)
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "EEEE, d MMM yyyy h:mm a"
        
        guard let localDateTime = dateTime else { return "No date set" }
        return newDateFormatter.string(from: localDateTime)
    }
}
