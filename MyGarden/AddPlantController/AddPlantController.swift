//
//  AddPlantController.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class AddPlantController: UIViewController {

    public enum SectionsAddPlant: CaseIterable {
        case name
        case kind
        case description
    }
    
    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    let plantService = CDPlantService()
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
        if currentPlant == nil {
            // create new plant
        } else {
            // save current plant
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddPlantController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionsAddPlant.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionCell.reuseId, for: indexPath) as! DataCollectionCell
        cell.configureCellWith(currentPlant, section: SectionsAddPlant.allCases[indexPath.row])
        
        return cell
    }
    
}

extension AddPlantController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 95)
    }
    
}
