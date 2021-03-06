//
//  DailyListTableViewController.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 21.06.2021.
//

import UIKit

class DailyListTableViewController: UIViewController {
    
    var dataManager = DataManager.shared
    var dateForSegue: Int?
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(GalleryTableViewCell.self, forCellReuseIdentifier: "galleryCell")
        return table
    }()
    
// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataManager.listDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1.0
        view.addSubview(tableView)
        
        self.title = "Flickr Daily Photos"
        dataManager.fetchGalleries(for: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}



// MARK: - UITableViewDataSource

extension DailyListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataManager.galleriesCount
                
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell", for: indexPath) as! GalleryTableViewCell
        let gallery = dataManager.getGalleryForCell(in: indexPath.row)
        cell.galleryData = gallery
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension DailyListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataManager.galleriesCount - 1,
           let visibleRows = self.tableView.indexPathsForVisibleRows,
            visibleRows.contains(indexPath),
            self === self.navigationController?.topViewController {
            
            print("new request")
            dataManager.fetchGalleries(for: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gallery = dataManager.getWholeGallery(for: indexPath.row)
        if let isEmpty = gallery.imageURLs?.isEmpty, isEmpty { return }
        
        let galleryViewController = GalleryViewController()
        dataManager.galleryDelegate = galleryViewController.self
        galleryViewController.galleryData = gallery
        navigationController?.pushViewController(galleryViewController, animated: true)
        
    }
    
}

// MARK: - DataManagerDelegate

extension DailyListTableViewController: DataManagerListDelegate {
    
    func updatedGallery(_ gallery: GalleryData, at indexPath: IndexPath) {
        DispatchQueue.main.async {
            
            let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! GalleryTableViewCell
                        
            cell.galleryData = gallery

            if let visibleRows = self.tableView.indexPathsForVisibleRows,
               visibleRows.contains(indexPath),
               self === self.navigationController?.topViewController {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func galleryDidLoad() {
        DispatchQueue.main.async {
            
            if self === self.navigationController?.topViewController {
                self.tableView.reloadData()
            }
        }
    }
    
    func showNetworkError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Network Error!",
                                          message: "Please check the connection.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                print("Retry...(connection)")
                self.dataManager.fetchGalleries(for: 0)
            }))
            
            self.present(alert, animated: true)
        }
    }
}
