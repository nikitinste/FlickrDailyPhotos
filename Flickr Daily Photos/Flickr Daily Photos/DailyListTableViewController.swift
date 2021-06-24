//
//  DailyListTableViewController.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 21.06.2021.
//

import UIKit

class DailyListTableViewController: UIViewController {
    
    var dataManager = DataManager.shared
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(GalleryTableViewCell.self, forCellReuseIdentifier: "galleryCell")
        return table
    }()
    
// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataManager.delegate = self
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
        
        print(count)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell", for: indexPath) as! GalleryTableViewCell
        
        
        let gallery = dataManager.getGallery(for: indexPath.row)
        
//        gallegy.images = [UIImage(named: "rocketLaunch")!, UIImage(named: "fields")!, UIImage(named: "girl")!, UIImage(named: "bird")!]

        cell.galleryData = gallery
        
        print("Cell for row: \(indexPath.row) with urls:\n\(gallery.imageURLs)")
//        print("cell for row at index: \(indexPath.row)")
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension DailyListTableViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row >= dataManager.galleriesCount - 1 {
//            dataManager.fetchGalleries(for: indexPath.row)
//        }
//    }
    
}

// MARK: - DataManagerDelegate

extension DailyListTableViewController: DataManagerDelegate {
    
    func updatedGallery(_ gallery: GalleryData, at indexPath: IndexPath) {
        DispatchQueue.main.async {
            
            let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! GalleryTableViewCell
            
//            print("update gallery ...")
            
            cell.galleryData = gallery
//                print("success!       ...")
//                self.tableView.reloadData()
            if let visibleRows = self.tableView.indexPathsForVisibleRows,
               visibleRows.contains(indexPath),
               self === self.navigationController?.topViewController {
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }
        
//            if cell.galleryData?.date == gallery.date {
//
//            }/* else { print("failure ((( .......................") }*/
            
            
            // set gallery to cell, reload row
        }
    }
    
    func galleryDidLoad() {
        DispatchQueue.main.async {
//            self.dataManager.galleriesCount += 1
            print("Data reloading")
            self.tableView.reloadData()
        }
    }
}
