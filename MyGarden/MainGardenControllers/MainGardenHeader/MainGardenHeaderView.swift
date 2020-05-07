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
    
    @IBOutlet weak var noPlantToWaterLabel: UILabel!
    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var addPlantButton: UIButton!
    
    weak var delegate: MainGardenHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurateCellUI()
        configurateConllectionView()
    }
    
    fileprivate func configurateCellUI() {
        addPlantButton.layer.cornerRadius = Constants.buttonCornerRadius
        plantsCollectionView.backgroundColor = .white
        noPlantToWaterLabel.alpha = 1.0
    }
    
    fileprivate func configurateConllectionView() {
        plantsCollectionView.register(MainGardenHeaderCollectionCell.self, forCellWithReuseIdentifier: MainGardenHeaderCollectionCell.reuseId)
        plantsCollectionView.delegate = self
        plantsCollectionView.dataSource = self
    }
    
    @IBAction func addPlantButtonTapped(_ sender: UIButton) {
        delegate?.addNewPlant()
    }
    
}

extension MainGardenHeaderView: UICollectionViewDelegateFlowLayout {
    
}

extension MainGardenHeaderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainGardenHeaderCollectionCell.reuseId, for: indexPath) as! MainGardenHeaderCollectionCell
        
        
        return cell
    }
    
}
