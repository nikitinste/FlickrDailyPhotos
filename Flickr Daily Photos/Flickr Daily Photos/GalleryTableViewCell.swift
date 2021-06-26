//
//  GalleryTableViewCell.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 21.06.2021.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    
    
    let spasing: CGFloat = 5.0
    
    var mainImageView: UIImageView?
    var leftImageView: UIImageView?
    var centerImageView: UIImageView?
    var rightImageView: UIImageView?
    var mainStackView: UIStackView?
    var detailStackView: UIStackView?
    var dateLabel: UILabel?
    
    var galleryData: GalleryData? {
        didSet {
            guard let gallery = galleryData else { return }
            
            
            dateLabel?.text = labelString(for: gallery.date)
            dateLabel?.isEnabled = true
            
            if let mainImage = gallery.images[0] {
                
                mainImageView?.image = mainImage
                let ratio = mainImage.size.width / mainImage.size.height
                mainImageView?.widthAnchor.constraint(equalTo: mainImageView!.heightAnchor,
                                                      multiplier: ratio).isActive = true
            }
            
            if let leftImage = gallery.images[1],
                let centerImage = gallery.images[2],
                let rightImage = gallery.images[3] {
                
                leftImageView?.image = leftImage
                centerImageView?.image = centerImage
                rightImageView?.image = rightImage
                
                let centerImageScaleIndex = leftImage.size.height / centerImage.size.height
                let rightImageScaleIndex = leftImage.size.height / rightImage.size.height
                let centerImageScaledWidth = centerImage.size.width * centerImageScaleIndex
                let rightImageScaledWidth = rightImage.size.width * rightImageScaleIndex
                let leftImageRatio = leftImage.size.width / leftImage.size.height
                let centerImageRatio = centerImageScaledWidth / leftImage.size.height
                let rightImageRatio = rightImageScaledWidth / leftImage.size.height
                

                leftImageView?.widthAnchor.constraint(equalTo: leftImageView!.heightAnchor,
                                                      multiplier: leftImageRatio).isActive = true
                centerImageView?.widthAnchor.constraint(equalTo: centerImageView!.heightAnchor,
                                                        multiplier: centerImageRatio).isActive = true
                rightImageView?.widthAnchor.constraint(equalTo: rightImageView!.heightAnchor,
                                                       multiplier: rightImageRatio).isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelString(for date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let galleryDate = formatter.date(from: date)!
        let currentDate = DataManager.currentDate
        
        let daysAgo = Calendar.current.dateComponents([.day], from: galleryDate, to: currentDate).day!
        
        if daysAgo == 0 {
            return "Today"
        } else if daysAgo == 1 {
            return "Yesterday"
        }
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: galleryDate)
    }
    
    private func getLable() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func getDetailStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = spasing
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(leftImageView!)
        stackView.addArrangedSubview(centerImageView!)
        stackView.addArrangedSubview(rightImageView!)

        return stackView
    }
    
    private func getMainStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spasing
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        dateLabel = getLable()
        let containerView = UIView()
        containerView.addSubview(dateLabel!)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: spasing * 2).isActive = true
        dateLabel?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dateLabel?.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dateLabel?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -spasing).isActive = true
        
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(mainImageView!)
        
        detailStackView = getDetailStackView()
        stackView.addArrangedSubview(detailStackView!)

        return stackView
    }
    
    private func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func configureCell() {
        
        mainImageView = getImageView()
        leftImageView = getImageView()
        centerImageView = getImageView()
        rightImageView = getImageView()
        mainStackView = getMainStackView()
        
        self.addSubview(mainStackView!)
        
        mainStackView?.translatesAutoresizingMaskIntoConstraints = false
        mainStackView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView?.topAnchor.constraint(equalTo: self.topAnchor, constant: spasing).isActive = true
        mainStackView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spasing).isActive = true
    }
    
    override func prepareForReuse() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        mainImageView = nil
        leftImageView = nil
        centerImageView = nil
        rightImageView = nil
        mainStackView = nil
        detailStackView = nil
        dateLabel = nil
        
        configureCell()
    }
        
}
