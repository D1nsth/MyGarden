//
//  PlantDetailsViewController.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController {

    fileprivate let headerId = "headerId"
    fileprivate let paddingCollectionCell: CGFloat = 16
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
//        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    fileprivate func setupNavigationBar() {
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.tintColor = .white
            navigationBar.backgroundColor = .clear
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        }
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
        
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PlantDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: headerId)
    }
    
}

// MARK: UICollectionViewDataSource
extension PlantDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlantDetailsCollectionCell.REUSE_ID, for: indexPath) as! PlantDetailsCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        
        return header
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlantDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = ((scrollView.contentOffset.y / 170) - 1.2) * 5
        offset = (offset < 0) ? 0 : offset
        offset = min(1, offset)
        
        let backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.tintColor = UIColor(white: (1 - offset), alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: offset)]
        UIApplication.shared.statusBarUIView?.backgroundColor = backgroundColor
    }
    
}
