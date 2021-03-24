//
//  EventTableViewCell.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/17/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var eventFavorited = false
    var eventDateFormatter = EventDateFormatter()
    
    // MARK: - Outlets
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
    var event: Event? {
        didSet {
            loadEvents()
        }
    }
    
    // MARK: - Helper Functions
    private func loadEvents() {
        guard let event = event else { return }
        
        eventTitleLabel.text = event.title
        eventLocationLabel.text = event.venue.displayLocation
        eventDateTimeLabel.text = eventDateFormatter.dateFormatter(apiDateTime: event.dateTime)
        
        NetworkManager.shared.fetchImageFor(event: event) { (image) in
            DispatchQueue.main.async { [self] in
                switch image {
                
                case .success(let image):
                    eventImageView.image = image
                case .failure(let error):
                    print(error.errorDescription ?? "No image to set")
                }
            }
        }
        
        eventImageView.makeRoundCorners(byRadius: 15)
        
        // Checks if event has been favorited
        eventFavorited = false
        for favorite in FavoriteController.shared.favorites {
            if event.id == favorite.id {
                eventFavorited = true
            }
        }
        isEventFavorited()
    }
    
    // Shows if event is favorited in tableView
    func isEventFavorited() {
        if eventFavorited == false {
            favoriteIcon.image = UIImage()
        } else if eventFavorited == true {
            favoriteIcon.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed)
        }
    }
}

extension UIImageView {
    func makeRoundCorners(byRadius rad: CGFloat) {
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
    }
}
