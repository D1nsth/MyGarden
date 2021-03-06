//
//  PlantImageHeaderViewCell.swift
//  MyGarden
//
//  Created by Никита on 01.05.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class PlantImageHeaderViewCell: UICollectionViewCell {
    
    static let reuseId = "PlantDetailsHeaderCellReuseId"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "default-plant"))
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.7568627451, blue: 0.6980392157, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
    }
    
    public func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    public func getImage() -> UIImage? {
        return imageView.image
    }
    
}

