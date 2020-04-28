//
//  DataCollectionCell.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class DataCollectionCell: UICollectionViewCell {
    
    static let reuseId = "dataCollectionCellReuseId"
    
    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var inputDataTextField: UITextField!
    
    public func configureCellWith(_ plant: PlantModel?, section: AddPlantController.SectionsAddPlant) {
        
        switch section {
        case .name:
            titleCellLabel.text = "Name"
        case .kind:
            titleCellLabel.text = "Kind"
        case .description:
            titleCellLabel.text = "Description"
        }
        
        
        if let plant = plant {
            switch section {
            case .name:
                inputDataTextField.text = plant.name ?? ""
                
            case .kind:
                inputDataTextField.text = plant.kind
                
            case .description:
                inputDataTextField.text = plant.description
                
            }
        } else {
             inputDataTextField.text = ""
        }
        
    }
    
}
