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
    
    private let showDetailsSegueId = "showPlantDetailsSegue"
    private let showAddPlantSegueId = "showAddNewPlantSegue"
    private let plantService = CDPlantService()
    
    private var plants: [PlantModel] = []
    private var selectPlant: Int?
    
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
    
    private func setupCollectionView() {
        gardenCollectionView.dataSource = self
        gardenCollectionView.delegate = self
        
//        gardenCollectionView.contentInsetAdjustmentBehavior = .never
//        gardenCollectionView.backgroundColor = .white
        gardenCollectionView.register(MainGardenHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainGardenHeaderView.reuseId)
    }
    
    private func setupCollectionLayout() {
        if let layout = gardenCollectionView.collectionViewLayout as? GardenCollectionFlowLayout {
            layout.sectionInset = .init(top: 0,
                                        left: Constants.mainInsets.left,
                                        bottom: Constants.mainInsets.bottom,
                                        right: Constants.mainInsets.right)
        }
    }
    
    private func updateNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .black
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        }
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GardenCollectionCell.reuseId, for: indexPath) as! GardenCollectionCell
        
        // TODO: перенести
        let plant = plants[indexPath.row]
        let image = plant.images.first ?? #imageLiteral(resourceName: "default-plant")
        let name = plant.name ?? ""
        let titleCell = (name.isEmpty) ? plant.kind : name
        cell.configureCellWith(image, andName: titleCell)
        cell.layer.cornerRadius = Constants.buttonCornerRadius
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainGardenHeaderView.reuseId, for: indexPath) as! MainGardenHeaderView
        header.delegate = self
        
        return header
    }
    
}

extension MainGardenController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPlant = indexPath.row
        performSegue(withIdentifier: showDetailsSegueId, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: Constants.mainGardenHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - (Constants.mainInsets.left + Constants.mainInsets.right)
        return .init(width: width, height: width * 1.3)
    }
    
}

extension MainGardenController: MainGardenHeaderDelegate {
    
    func addNewPlant() {
        performSegue(withIdentifier: showAddPlantSegueId, sender: self)
    }
    
}
