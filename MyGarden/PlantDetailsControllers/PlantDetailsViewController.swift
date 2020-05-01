//
//  PlantDetailsViewController.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController {

    public enum SectionsDetails {
        case kind
        case description
    }
    
    @IBOutlet weak var customNavBackgroundView: UIView!
    @IBOutlet weak var customTitleNavLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let editDetailsSegueId = "editPlantDetailsSegue"
    fileprivate let paddingCollectionCell: CGFloat = 16
    fileprivate let plantService = CDPlantService()
    
    fileprivate var isDarkStatusBar: Bool = false
    fileprivate var sections: [SectionsDetails] = [.kind, .description]
    
    var currentPlant: PlantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
//        setupCollectionViewLayout()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCurrentPlant()
        setupSectionsCell()
        updateNavigationBar()
        
        collectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (isDarkStatusBar) ? .default : .lightContent
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
    
    fileprivate func setupCollectionViewLayout() {
        // layout customization
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: paddingCollectionCell,
                                        left: paddingCollectionCell,
                                        bottom: paddingCollectionCell,
                                        right: paddingCollectionCell)
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(PlantImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlantImageHeaderView.reuseId)
    }
    
    fileprivate func setupSectionsCell() {
        sections = [.kind, .description]
        
        if let descriptionPlant = currentPlant?.description {
            if descriptionPlant.isEmpty {
                sections.removeAll { $0 == .description}
            }
            
        } else {
            sections.removeAll { $0 == .description}
        }
    }
    
    fileprivate func updateCurrentPlant() {
        if let id = currentPlant?.id {
            currentPlant = plantService.getPlantById(id)
        }
        //        else {
        // TODO: Failed get id -> pop view controller
        //        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editDetailsSegueId {
            if let nextController = segue.destination as? AddPlantController {
                nextController.currentPlant = currentPlant
            }
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension PlantDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let plant = currentPlant else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantDetailsCollectionCell.reuseId, for: indexPath) as! PlantDetailsCollectionCell
        cell.configureCellWith(plant, section: sections[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlantImageHeaderView.reuseId, for: indexPath) as! PlantImageHeaderView
        
        if let plant = currentPlant {
            let plantName = plant.name ?? ""
            let title = (plantName.isEmpty) ? plant.kind : plantName
            
            customTitleNavLabel.text = title
            header.setImages(plant.images, withTitle: title)
        }
        
        return header
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlantDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Высчитывать высоту динамически
        return .init(width: view.frame.width, height: 73)
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
