//
//  PlantDetailsCollectionCell.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class PlantDetailsCollectionCell: UICollectionViewCell {
    
    static let reuseId = "detailsCollectionCellReuseId"
    
    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var textForCellLabel: UILabel!
    
    public func configureCellWith(_ plant: PlantModel, section: PlantDetailsViewController.SectionsDetails) {

        switch section {
            
        case .kind:
            titleCellLabel.text = "Kind"
            textForCellLabel.text = plant.kind
            
        case .description:
            titleCellLabel.text = "Description"
            textForCellLabel.text = plant.description
        }
        
    }
    
}
