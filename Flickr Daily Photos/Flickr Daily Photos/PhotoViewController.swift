//
//  PhotoViewController.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 25.06.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    private var imageView: UIImageView?
    private var photoImage: UIImage?
    private var index: Int
    
    var delegate: PhotoViewControllerDelegate?
    var page: Pages

    init(with page: Pages, photo: UIImage?, index: Int) {
        self.page = page
        self.photoImage = photo
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(frame: self.view.frame)
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = photoImage
        self.view.addSubview(imageView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.photoViewWillAppear(at: index)
    }

}

protocol PhotoViewControllerDelegate {
    func photoViewWillAppear(at index: Int) -> Void
}
