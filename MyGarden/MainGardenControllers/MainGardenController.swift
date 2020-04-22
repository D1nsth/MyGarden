//
//  MainGardenController.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class MainGardenController: UIViewController {
    
    @IBOutlet weak var gardenCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gardenCollectionView.dataSource = self
        gardenCollectionView.delegate = self
    }

}

extension MainGardenController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GardenCollectionCell.REUSE_ID, for: indexPath) as! GardenCollectionCell
        
        return cell
    }
    
}

extension MainGardenController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width / 2 - 20, height: 200)
    }
    
}
