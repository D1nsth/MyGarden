//
//  MainGardenHeaderView.swift
//  MyGarden
//
//  Created by Никита on 05.05.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

protocol MainGardenHeaderDelegate: class {
    func addNewPlant()
}

class MainGardenHeaderView: UICollectionReusableView {
        
    static let reuseId = "mainGardenHeaderReuseId"
    static let nib = UINib(nibName: String(describing: MainGardenHeaderView.self), bundle: nil)
    
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var addPlantButton: UIButton!
    
    weak var delegate: MainGardenHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPlantButton.layer.cornerRadius = 16
        plantsCollectionView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    }
    
    @IBAction func addPlantButtonTapped(_ sender: UIButton) {
        delegate?.addNewPlant()
    }
    
}
