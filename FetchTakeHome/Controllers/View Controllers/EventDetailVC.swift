//
//  EventDetailVC.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/17/21.
//

import UIKit

class EventDetailVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    // MARK: - Properties
    var event: Event?
    var eventDateFormatter = EventDateFormatter()
    var isFavorite: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }

    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let event = event else { return }
        
        if isFavorite == false {
            FavoriteController.shared.addFavorite(from: event.id)
        } else {
            FavoriteController.shared.removeFavorite(eventID: event.id)
        }
        isFavorite.toggle()
        favoriteButtonStatus()
    }
    
    // MARK: - Helper Functions
    func updateViews() {
        guard let event = event else { return }
        eventTitleLabel.text = event.title
        
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
        eventImageView.makeRoundCorners(byRadius: 10)
        
        eventDateTimeLabel.text = eventDateFormatter.dateFormatter(apiDateTime: event.dateTime)
        eventLocationLabel.text = event.venue.displayLocation
        favoriteButtonStatus()
    }
    
    func favoriteButtonStatus() {
        guard let event = event else { return }
        for favorite in FavoriteController.shared.favorites {
            if favorite.id == event.id {
                isFavorite = true
            }
        }
        if isFavorite == true {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .systemRed
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .systemRed
        }
    }
}


