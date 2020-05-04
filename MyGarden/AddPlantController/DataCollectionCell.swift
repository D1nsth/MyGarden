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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var kindTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    public func getName() -> String {
        return nameTextField.text ?? ""
    }
    
    public func getKind() -> String {
        return kindTextField.text ?? ""
    }
    
    public func getDescription() -> String {
        return descriptionTextField.text ?? ""
    }
    
    public func configureCellWith(_ plant: PlantModel?) {
        guard let plant = plant else {
            print("(DataCollectionCell): Failed get plant")
            return
        }
        
        nameTextField.text = plant.name
        kindTextField.text = plant.kind
        descriptionTextField.text = plant.description
        
    }
    
}
