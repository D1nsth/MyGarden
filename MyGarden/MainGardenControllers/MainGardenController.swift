//
//  MainGardenController.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class MainGardenController: UIViewController {
    
    fileprivate let SHOW_DETAILS_SEGUE_ID = "showPlantDetailsSegue"
    
    @IBOutlet weak var gardenCollectionView: UICollectionView!
    
    let plants: [PlantModel] = [PlantModel(name: "Kek1", kind: "What", description: "123", image: nil),
                                PlantModel(name: "Kek2", kind: "Keker", description: "321", image: #imageLiteral(resourceName: "batman")),
                                PlantModel(name: "Kek3", kind: "Kyker", description: "630", image: #imageLiteral(resourceName: "plant"))]
    var selectPlant: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar()
    }
    
    fileprivate func setupCollectionView() {
        gardenCollectionView.dataSource = self
        gardenCollectionView.delegate = self
    }
    
    fileprivate func updateNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SHOW_DETAILS_SEGUE_ID {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GardenCollectionCell.REUSE_ID, for: indexPath) as! GardenCollectionCell
        
        let plant = plants[indexPath.row]
        let image = plant.image ?? #imageLiteral(resourceName: "default-plant")
        let name = plant.name ?? ""
        cell.configureCellWith(image, andName: name)
        
        return cell
    }
    
}

extension MainGardenController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPlant = indexPath.row
        performSegue(withIdentifier: SHOW_DETAILS_SEGUE_ID, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width / 2 - 20, height: 200)
    }
    
}
