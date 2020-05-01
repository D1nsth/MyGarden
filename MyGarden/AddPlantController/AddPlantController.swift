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
    
    fileprivate let plantService = CDPlantService()
    var currentPlant: PlantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    fileprivate func setupCollectionView() {
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
    }
    
    fileprivate func updateNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func savePlantTapped(_ sender: Any) {
        if let cell = dataCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? DataCollectionCell {
            let name = cell.getName()
            let kind = cell.getKind()
            let description = cell.getDescription()
            
            if currentPlant == nil {
                // create new plant
                let count = plantService.getCountPlant()
                // TODO: Images
                plantService.createPlantWithId(count + 1, name: name, kind: kind, description: description, images: nil)
            } else {
                // save current plant
                // TODO: Images
                plantService.updatePlantWithId(currentPlant!.id, name: name, kind: kind, description: description, images: nil)
            }
        } else {
            // TODO: Error save
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddPlantController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionCell.reuseId, for: indexPath) as! DataCollectionCell
        cell.configureCellWith(currentPlant)
        
        return cell
    }
    
}

extension AddPlantController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 258)
    }
    
}
