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
        case waterSchedule
    }
    
    @IBOutlet weak var customNavBackgroundView: UIView!
    @IBOutlet weak var customTitleNavLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let editDetailsSegueId = "editPlantDetailsSegue"
    private let plantService = CDPlantService()
    
    private var isDarkStatusBar: Bool = false
    private var sections: [SectionsDetails] = [.kind, .description, .waterSchedule]
    
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
    
    private func setupNavigationBar() {
        customNavBackgroundView.alpha = 0.0
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = .clear
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        }
    }
    
    private func updateNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout  else {
            return
        }
        
        // layout customization
        layout.sectionInset = Constants.mainInsets
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(PlantImageHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlantImageHeaderView.reuseId)
    }
    
    private func setupSectionsCell() {
        sections = [.kind, .description, .waterSchedule]
        
        guard currentPlant?.description?.isEmpty ?? true else {
            return
        }
        sections.removeAll { $0 == .description}
    }
    
    private func updateCurrentPlant() {
        if let id = currentPlant?.id {
            currentPlant = plantService.getPlantById(id)
            collectionView.reloadData()
            
        } else {
            print("(PlantDetailsViewController): Failed get id for update current plant ")
            navigationController?.popViewController(animated: true)
        }
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
        
        guard let plant = currentPlant else {
            return header
        }
        
        let plantName = plant.name ?? ""
        let title = (plantName.isEmpty) ? plant.kind : plantName
        
        customTitleNavLabel.text = title
        header.setImages(plant.images, withTitle: title, isActions: false)
        
        return header
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlantDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let plant = currentPlant else {
            return .init(width: view.frame.width, height: 0)
        }
        
        var textCell: String
        switch sections[indexPath.row] {
        case .kind:
            textCell = plant.kind
            
        case .description:
            textCell = plant.description ?? ""
            
        case .waterSchedule:
            textCell = PlantModel.scheduleWaterData[indexPath.row - 1]
        }

        let widthText = view.frame.width - Constants.mainInsets.left - Constants.mainInsets.right
        let height = textCell.height(width: widthText,
                                     font: Constants.descriptionFont)
        //                                       bottomAnchor + topAnchor + heightTitleLabel
        return .init(width: view.frame.width, height: height + 10 + 10 + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: Constants.headerImageHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = ((scrollView.contentOffset.y / (Constants.headerImageHeight / 2)) - 1.2) * 5
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
