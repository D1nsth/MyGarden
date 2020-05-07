//
//  AddPlantFooterViewCell.swift
//  MyGarden
//
//  Created by Никита on 07.05.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

protocol AddPlantFooterDelegate: class {
    func deletePlant()
}

class AddPlantFooterViewCell: UICollectionReusableView {
    
    static let reuseId = "AddPlantFooterViewReuseId"
    weak var delegate: AddPlantFooterDelegate?
    
    let deletePlantButton: UIButton = {
       let button = UIButton()
        button.setTitle("Delete plant", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = #colorLiteral(red: 0.8305622329, green: 0.05539893594, blue: 0.07002168258, alpha: 1)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupButton() {
        addSubview(deletePlantButton)
        deletePlantButton.addTarget(self, action: #selector(deletePlantButtonTapped), for: .touchUpInside)
        deletePlantButton.anchor(top: topAnchor,
                                 leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    @objc fileprivate func deletePlantButtonTapped() {
        delegate?.deletePlant()
    }
    
}

