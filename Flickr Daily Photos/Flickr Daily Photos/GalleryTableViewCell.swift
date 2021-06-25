//
//  GalleryTableViewCell.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 21.06.2021.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    
    let spasing: CGFloat = 5.0
    
    var mainImageView: UIImageView = UIImageView()
    var leftImageView: UIImageView = UIImageView()
    var centerImageView: UIImageView = UIImageView()
    var rightImageView: UIImageView = UIImageView()
    
    var imageConstraints: [NSLayoutConstraint] = []
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spasing
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        let containerView = UIView()
        containerView.addSubview(dateLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: spasing * 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -spasing).isActive = true
        
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(mainImageView)
        stackView.addArrangedSubview(detailStackView)

        return stackView
    }()
    
    lazy var detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = spasing
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(centerImageView)
        stackView.addArrangedSubview(rightImageView)

        return stackView
    }()
    
    private func labelString(for date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let galleryDate = formatter.date(from: date)!
        let currentDate = DataManager.getDate()
        
        let daysAgo = Calendar.current.dateComponents([.day], from: galleryDate, to: currentDate).day!
        
        if daysAgo == 0 {
            return "Today"
        } else if daysAgo == 1 {
            return "Yesterday"
        }
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: galleryDate)
    }
    
    var galleryData: GalleryData? {
        didSet {
            guard let gallery = galleryData else { return }
            
            
            dateLabel.text = labelString(for: gallery.date)
            dateLabel.isEnabled = true
            
            if let mainImage = gallery.images[0] {
                mainImageView.image = mainImage
                let ratio = mainImage.size.width / mainImage.size.height
                imageConstraints.append(mainImageView.widthAnchor.constraint(equalTo: mainImageView.heightAnchor,
                                                     multiplier: ratio))
            }
            
            if let leftImage = gallery.images[1],
                let centerImage = gallery.images[2],
                let rightImage = gallery.images[3] {
                leftImageView.image = leftImage
                centerImageView.image = centerImage
                rightImageView.image = rightImage
                
                let centerImageScaleIndex = leftImage.size.height / centerImage.size.height
                let rightImageScaleIndex = leftImage.size.height / rightImage.size.height
                let centerImageScaledWidth = centerImage.size.width * centerImageScaleIndex
                let rightImageScaledWidth = rightImage.size.width * rightImageScaleIndex
                let leftImageRatio = leftImage.size.width / leftImage.size.height
                let centerImageRatio = centerImageScaledWidth / leftImage.size.height
                let rightImageRatio = rightImageScaledWidth / leftImage.size.height
                

                imageConstraints.append(leftImageView.widthAnchor.constraint(equalTo: leftImageView.heightAnchor,
                                                                             multiplier: leftImageRatio))
                imageConstraints.append(centerImageView.widthAnchor.constraint(equalTo: centerImageView.heightAnchor,
                                                                               multiplier: centerImageRatio))
                imageConstraints.append(rightImageView.widthAnchor.constraint(equalTo: rightImageView.heightAnchor,
                                                                              multiplier: rightImageRatio))
            }
            
            NSLayoutConstraint.activate(imageConstraints)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        mainImageView.contentMode = .scaleAspectFit
        leftImageView.contentMode = .scaleAspectFit
        centerImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        mainImageView.backgroundColor = .yellow
        leftImageView.backgroundColor = .yellow
        centerImageView.backgroundColor = .yellow
        rightImageView.backgroundColor = .yellow
        
        self.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: spasing).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spasing).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        mainImageView.removeConstraints(mainImageView.constraints)
        leftImageView.removeConstraints(leftImageView.constraints)
        centerImageView.removeConstraints(centerImageView.constraints)
        rightImageView.removeConstraints(rightImageView.constraints)
        
        self.removeConstraints(imageConstraints)
        imageConstraints.removeAll()
        
        mainImageView.image = nil
        leftImageView.image = nil
        centerImageView.image = nil
        rightImageView.image = nil
    }
        
}
