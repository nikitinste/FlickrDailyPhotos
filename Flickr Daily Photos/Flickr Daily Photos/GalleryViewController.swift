//
//  GalleryViewController.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 25.06.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var galleryData: GalleryData!
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var pages: [Pages] = Pages.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground

        setupPageController()
    }
    
    
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll,
                                                   navigationOrientation: .horizontal,
                                                   options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: self.view.frame.width,
                                                 height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        
        let initialVC = PhotoViewController(with: pages[0])
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
        
        
    }

}

extension GalleryViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentViewController = viewController as? PhotoViewController else {
            return nil
        }
        
        var index = currentViewController.page.index
        if index == 0 {
            return nil
        }
        index -= 1
        let viewController: PhotoViewController = PhotoViewController(with: pages[index])
        
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentViewController = viewController as? PhotoViewController else {
            return nil
        }
        
        var index = currentViewController.page.index
        if index >= self.pages.count - 1 {
            return nil
        }
        index += 1
        let viewController: PhotoViewController = PhotoViewController(with: pages[index])
        
        return viewController
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
    
}

extension GalleryViewController: UIPageViewControllerDelegate {
    
}
