//
//  DataManager.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 23.06.2021.
//

import Foundation
import UIKit

class DataManager {
    
    static var shared = DataManager()
    
    let session: URLSession
    
    var delegate: DataManagerDelegate!
    var galleriesCount: Int = 0
    let galleriesAtRequest: Int = 20
    private var galleries: [String: GalleryData] = [:]
    private var imageCache = NSCache<NSString, NSData>()
    
    
    static func getDate() -> Date {
        Date()
    }
    
    // MARK: - private
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    private func galleryQueryItems() -> [String: String] {
        [
            "method": "flickr.interestingness.getList",
            "api_key": key,
            "format": "json",
            "nojsoncallback": "?",
            "page": "1",
            "per_page": "10"
        ]
    }
    
    private func galleryURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        
        return components
    }
    
    private func photoURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "live.staticflickr.com"
        components.path = "/"
        
        return components
    }
    
    private func dateForIndex(_ index: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -index, to: DataManager.getDate())!
        
        return date
    }
    
    private func dateString(for index: Int) -> String {
        let date = dateForIndex(index)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        return formatter.string(from: date)
    }
    
    private func rowForDate(_ dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let stringDate = formatter.date(from: dateString)!
        let currentDate = dateForIndex(0)
        
        return Calendar.current.dateComponents([.day], from: stringDate, to: currentDate).day!
    }
    
    private func addGallery(with photos: [PhotoInfo], for date: String) {
        var urls: [URL] = []
        var titles: [String] = []
        for photoInfo in photos {
            let photoURLpath = "\(photoInfo.server)/\(photoInfo.id)_\(photoInfo.secret).jpg"
            var urlComonents = photoURLComponents()
            urlComonents.path.append(photoURLpath)
            urls.append(urlComonents.url!)
            titles.append(photoInfo.title)
            
        }
        if urls.isEmpty {
            print(":( No photos for date: \(date)")
        }
        let gallery = GalleryData(date: date, titles: titles, imageURLs: urls)
        galleries[date] = gallery
    }
    
    private func getGalleryForDate(_ date: String) -> GalleryData? {
        if var gallery = galleries[date],
           let photoURLs = gallery.imageURLs {
            for (index, url) in photoURLs.enumerated() {
                if let imageData = imageCache.object(forKey: url.absoluteString as NSString) {
                    let image = UIImage(data: imageData as Data)
                    gallery.images[index] = image
                }
            }
        return gallery
        }
        return nil
    }
    
    private func fetсhPhoto(for date: String, by index: Int, from url: URL) {
//        guard index <= 3 else { return }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                
                self!.imageCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                
                let gallery = self!.getGalleryForDate(date)!
                let indexPath = IndexPath(row: self!.rowForDate(date), section: 0)
                if index <= 3 {
                    self!.delegate.updatedGallery(gallery, at: indexPath)
                }
                
            } else if let error = error {
                //completion(.failure(error))
                print("Image fetching error:\n\(error)")
            } else {
                //completion(.failure(PhotoInfoError.imageDataMissing))
                print("Image data missing")
            }
            
        }
        task.resume()
    }
    
    // MARK: - internal
    
    func getGallery(for row: Int) -> GalleryData {
        let date = dateString(for: row)
        
        
        if var gallery = galleries[date],
           let photoURLs = gallery.imageURLs {
            for (index, url) in photoURLs.enumerated() {
                if let imageData = imageCache.object(forKey: url.absoluteString as NSString) {
                    let image = UIImage(data: imageData as Data)
                    gallery.images[index] = image
                    
                } else {
                    fetсhPhoto(for: gallery.date, by: index, from: url)
                }
            }
        return gallery
        }
        
        return GalleryData(date: date)
    }
    
    
    
    
    func fetchGalleries(for row: Int) {

        var urlComponents = galleryURLComponents()
        
        var completedTasks = 0
        
        for i in 0...(galleriesAtRequest - 1) {
            
            
            let date = dateString(for: row + i)
            var queryItems = galleryQueryItems()
            queryItems["date"] = date
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            
            let task = session.dataTask(with: urlComponents.url!) { [weak self] (data, response, error) in
                let jsonDecoder = JSONDecoder()
                if let data = data {
                    do {
                        let galleryResponse = try jsonDecoder.decode(GalleryResponse.self, from: data)
                        //completion(.success(galleryResponse))
                        let photos = galleryResponse.gallery.photos
                        self?.addGallery(with: photos, for: date)
                        completedTasks += 1
                        if completedTasks == 10 {
                            self?.galleriesCount += self!.galleriesAtRequest
                            self?.delegate.galleryDidLoad()
                        }
                    } catch {
                        //completion(.failure(error))
                        print("JSON Decoding failure for date \(date)")
                        completedTasks += 1
                        if completedTasks == 10 {
                            self?.galleriesCount += self!.galleriesAtRequest
                            self?.delegate.galleryDidLoad()
                        }
                    }
                } else if let error = error {
                    //completion(.failure(error))
                    print("Galleries fetching error:\n\(error)")
                }
            }
            task.resume()
            
            
            
        }
    }
    
    
    
}

protocol DataManagerDelegate {
    func updatedGallery(_ gallery: GalleryData, at indexPath: IndexPath) -> Void
    func galleryDidLoad() -> Void
}
