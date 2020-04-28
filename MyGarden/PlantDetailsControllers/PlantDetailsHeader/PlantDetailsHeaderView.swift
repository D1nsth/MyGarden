//
//  PlantDetailsHeaderView.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class PlantDetailsHeaderView: UICollectionReusableView {
        
    static let reuseId = "PlantDetailsHeaderReuseId"
    
    var plantImages: [UIImage] = []
    var collectionImageView: UICollectionView?
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "default-plant"))
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.7568627451, blue: 0.6980392157, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionImageView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionImageView?.showsHorizontalScrollIndicator = false
        collectionImageView?.isPagingEnabled = true
        collectionImageView?.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.7568627451, blue: 0.6980392157, alpha: 1)
        
        collectionImageView?.delegate = self
        collectionImageView?.dataSource = self
        collectionImageView?.register(PlantDetailsHeaderViewCell.self, forCellWithReuseIdentifier: PlantDetailsHeaderViewCell.reuseId)
    }
    
    fileprivate func setupLayout() {
        addSubview(collectionImageView!)
        collectionImageView?.anchor(top: topAnchor,
                                    leading: leadingAnchor,
                                    bottom: bottomAnchor,
                                    trailing: trailingAnchor)
        
        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    public func setImages(_ images: [UIImage]?, withTitle title: String) {
        plantImages = images ?? []
        titleLabel.text = title
    }
    
}

extension PlantDetailsHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (plantImages.count != 0) ? plantImages.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantDetailsHeaderViewCell.reuseId, for: indexPath) as! PlantDetailsHeaderViewCell
        if plantImages.count == 0 {
            cell.setImage(#imageLiteral(resourceName: "default-plant"))
            
        } else {
            cell.setImage(plantImages[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImageView!.frame.width, height: collectionImageView!.frame.height)
    }
    
}
