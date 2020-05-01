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
    @IBOutlet weak var customNavBackgroundView: UIView!
    @IBOutlet weak var customTitleNavLabel: UILabel!
    
    fileprivate let plantService = CDPlantService()
    
    fileprivate var isDarkStatusBar: Bool = false
    var currentPlant: PlantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (isDarkStatusBar) ? .default : .lightContent
    }
    
    fileprivate func setupCollectionView() {
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        
        dataCollectionView.contentInsetAdjustmentBehavior = .never
        dataCollectionView.register(PlantImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlantImageHeaderView.reuseId)
    }
    
    fileprivate func setupNavigationBar() {
        customNavBackgroundView.alpha = 0.0
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = .clear
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        }
    }
    
    fileprivate func updateNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlantImageHeaderView.reuseId, for: indexPath) as! PlantImageHeaderView
        header.delegate = self
        
        if let plant = currentPlant {
            let plantName = plant.name ?? ""
            let title = (plantName.isEmpty) ? plant.kind : plantName
            
            customTitleNavLabel.text = title
            header.setImages(plant.images, withTitle: title)
        }
        
        return header
    }
    
}

extension AddPlantController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 258)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = ((scrollView.contentOffset.y / 170) - 1.2) * 5
        offset = (offset < 0) ? 0 : offset
        offset = min(offset, 1)
        
        // update status bar
        isDarkStatusBar = (offset > 0.5)
        setNeedsStatusBarAppearanceUpdate()
        
        // Animation from custom large navigation bar to default
        customNavBackgroundView.alpha = offset
        navigationController?.navigationBar.tintColor = UIColor(white: (1 - offset), alpha: 1)
    }
    
}

extension AddPlantController: PlantImageHeaderViewDelegate {
    
    func presentView(_ view: UIViewController, animated: Bool) {
        present(view, animated: animated)
    }
    
    func dismissView(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
    
}
