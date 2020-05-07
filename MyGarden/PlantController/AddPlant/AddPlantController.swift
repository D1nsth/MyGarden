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
    fileprivate var newImages: [UIImage] = []
    
    fileprivate var isDarkStatusBar: Bool = false
    var currentPlant: PlantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotification()
        setupNavigationBar()
        setupCollectionView()
    }
    
    deinit {
        removeKeyboardNotification()
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
        dataCollectionView.register(AddPlantFooterViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: AddPlantFooterViewCell.reuseId)
        dataCollectionView.register(PlantImageHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlantImageHeaderView.reuseId)
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
            cell.checkTextFields()
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension AddPlantController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionCell.reuseId, for: indexPath) as! DataCollectionCell
        cell.configureCellWith(currentPlant)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // configure header view
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlantImageHeaderView.reuseId, for: indexPath) as! PlantImageHeaderView
            header.delegate = self
            
            guard let plant = currentPlant else {
                return header
            }
            
            let plantName = plant.name ?? ""
            let title = (plantName.isEmpty) ? plant.kind : plantName
            customTitleNavLabel.text = title
            header.setImages(plant.images, withTitle: title, isActions: true)
            
            return header
            
        // configure footer view
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AddPlantFooterViewCell.reuseId, for: indexPath) as! AddPlantFooterViewCell
            footer.delegate = self
            
            return footer
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension AddPlantController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: Constants.addPlantItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: Constants.headerImageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: Constants.footerAddPlantHeight)
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

extension AddPlantController: DataCollectionCellDelegate {
    
    func showAlertWith(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func savePlant() {
        guard let cell = dataCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? DataCollectionCell else {
            return
        }
        
        let name = cell.getName()
        let kind = cell.getKind()
        let description = cell.getDescription()
        let scheduleDay = cell.getScheduleDay()
        
        if currentPlant == nil {
            // create new plant
            // TODO: nextWateringDate
            plantService.createPlantWithName(name: name,
                                             kind: kind,
                                             description: description,
                                             images: newImages,
                                             waterSchedule: scheduleDay,
                                             nextWateringDate: Date.distantPast)
        } else {
            // save current plant
            plantService.updatePlantWithId(currentPlant!.id,
                                           name: name,
                                           kind: kind,
                                           description: description,
                                           images: currentPlant?.images,
                                           waterShedule: scheduleDay)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: PlantImageHeaderViewDelegate
extension AddPlantController: PlantImageHeaderViewDelegate {
    
    func presentView(_ view: UIViewController, animated: Bool) {
        present(view, animated: animated)
    }
    
    func dismissView(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
    
    func addImage(_ image: UIImage) {
        if currentPlant == nil {
            newImages.append(image)
        } else {
            currentPlant?.images.append(image)
        }
    }
    
    func deleteImageBy(_ indexImage: Int) {
        guard let id = currentPlant?.id else {
            print("(AddPlantController): Failed get id")
            return
        }
        
        currentPlant?.images.remove(at: indexImage)
        plantService.updatePlantWithId(id, images: currentPlant?.images)
    }
    
}

// MARK: AddPlantFooterDelegate
extension AddPlantController: AddPlantFooterDelegate {
    
    func deletePlant() {
        guard let id = currentPlant?.id else {
            print("(AddPlantController): Failed get id for delete")
            return
        }
        
        plantService.deletePlantBy(id)
        navigationController?.popToRootViewController(animated: true)
//        navigationController?.popViewController(animated: true)
    }
    
}
