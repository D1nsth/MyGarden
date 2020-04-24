//
//  AddPlantController.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class AddPlantController: UIViewController {

    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
}

extension AddPlantController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionCell.REUSE_ID, for: indexPath) as! DataCollectionCell
        
        return cell
    }
    
}

extension AddPlantController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 95)
    }
    
}
