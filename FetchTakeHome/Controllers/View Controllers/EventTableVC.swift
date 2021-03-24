//
//  EventTableVC.swift
//  FetchTakeHome
//
//  Created by Jimmy Brown on 3/17/21.
//

import UIKit

class EventTableVC: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var eventSearchBar: UISearchBar!
    @IBOutlet var eventTableView: UITableView!
    
    // MARK: - Properties
    var events: [Event] = []
    var searchController: UISearchController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        eventSearchBar.delegate = self
        FavoriteController.shared.loadFromPersistence()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        cell.event = events[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let eventDetailVC = segue.destination as? EventDetailVC,
              let selectRow = tableView.indexPathForSelectedRow?.row else {
            return
        }
        eventDetailVC.event = events[selectRow]
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        eventSearchBar.text = ""
        events = []
        eventTableView.reloadData()
    }
}

// MARK: - Helper Functions
extension EventTableVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        NetworkManager.shared.fetchEvents(searchTerm: searchTerm) { (results) in
            
            DispatchQueue.main.async {
                switch results {
                
                case .success(let results):
                    self.events = results
                case .failure(let error):
                    print(error.errorDescription ?? "Unable to fetch events")
                }
                self.eventTableView.reloadData()
            }
        }
    }
}

