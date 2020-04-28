//
//  GardenCollectionCell.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class GardenCollectionCell: UICollectionViewCell {
    
    static let reuseId = "gardenCollectionCellReuseId"
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    public func configureCellWith(_ image: UIImage, andName name: String) {
        plantImageView.image = image
        plantNameLabel.text = name
    }
    
}
