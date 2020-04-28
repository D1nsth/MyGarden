//
//  PlantDetailsViewController.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController {

    public enum SectionsDetails: CaseIterable {
        case kind
        case description
    }
    
    fileprivate let headerId = "headerId"
    fileprivate let EDIT_DETAILS_SEGUE_ID = "editPlantDetailsSegue"
    fileprivate let paddingCollectionCell: CGFloat = 16
    
    fileprivate var isDarkStatusBar: Bool = false
    var currentPlant: PlantModel?
    
    @IBOutlet weak var customNavBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
//        setupCollectionViewLayout()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar()
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
        
        collectionView.register(PlantDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: headerId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EDIT_DETAILS_SEGUE_ID {
            if let nextController = segue.destination as? AddPlantController {
                nextController.currentPlant = currentPlant
            }
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension PlantDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionsDetails.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let plant = currentPlant else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantDetailsCollectionCell.REUSE_ID, for: indexPath) as! PlantDetailsCollectionCell
        cell.configureCellWith(plant, section: SectionsDetails.allCases[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PlantDetailsHeaderView
        
        if let plant = currentPlant {
            let image = plant.image ?? #imageLiteral(resourceName: "default-plant")
            let name = plant.name ?? ""
            header.setImage(image, withTitle: name)
        }
        
        return header
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlantDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
