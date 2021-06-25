//
//  PhotoViewController.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 25.06.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
//    var titleLabel: UILabel?
    private var imageView: UIImageView?
    private var photoImage: UIImage?
    
    var page: Pages
    
    
//    var photoImage: UIImage? {
//        didSet {
//
//
//
//
//        }
//    }

    init(with page: Pages, photo: UIImage?) {
        self.page = page
        self.photoImage = photo
        
        if photo != nil {
            print("image!")
        } else {
            print("no image(")
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(frame: self.view.frame)
        imageView?.contentMode = .scaleAspectFit
//        imageView?.backgroundColor = .blue
//            imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.image = photoImage
        self.view.addSubview(imageView!)
    }

}
