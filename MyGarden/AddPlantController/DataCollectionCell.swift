//
//  DataCollectionCell.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class DataCollectionCell: UICollectionViewCell {
    
    static let REUSE_ID = "dataCollectionCellReuseId"
    
    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var inputDataTextField: UITextField!
    
}
