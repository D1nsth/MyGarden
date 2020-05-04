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
    
    fileprivate let showDetailsSegueId = "showPlantDetailsSegue"
    fileprivate let paddingCollectionCell: CGFloat = 16
    fileprivate let plantService = CDPlantService()
    
    fileprivate var plants: [PlantModel] = []
    fileprivate var selectPlant: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupCollectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        plants = plantService.getAllPlant()
        gardenCollectionView.reloadData()
        
        updateNavigationBar()
    }
    
    fileprivate func setupCollectionView() {
        gardenCollectionView.dataSource = self
        gardenCollectionView.delegate = self
    }
    
    fileprivate func setupCollectionLayout() {
        if let layout = gardenCollectionView.collectionViewLayout as? GardenCollectionFlowLayout {
            layout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
    
    fileprivate func updateNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailsSegueId {
            if let nextController = segue.destination as? PlantDetailsViewController,
                let numPlant = selectPlant {
                nextController.currentPlant = plants[numPlant]
            }
        }
    }
    
}

extension MainGardenController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GardenCollectionCell.reuseId, for: indexPath) as! GardenCollectionCell
        
        let plant = plants[indexPath.row]
        let image = plant.images.first ?? #imageLiteral(resourceName: "default-plant")
        let name = plant.name ?? ""
        let titleCell = (name.isEmpty) ? plant.kind : name
        cell.configureCellWith(image, andName: titleCell)
        cell.layer.cornerRadius = 16
        
        return cell
    }
    
}

extension MainGardenController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPlant = indexPath.row
        performSegue(withIdentifier: showDetailsSegueId, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - 24
        return .init(width: width, height: width * 1.3)
    }
    
}
