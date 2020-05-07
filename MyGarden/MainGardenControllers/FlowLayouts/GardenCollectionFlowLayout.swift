//
//  GardenCollectionFlowLayout.swift
//  MyGarden
//
//  Created by Никита on 22.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

class GardenCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
            guard let collectionView = collectionView else {
                return
                }
                
                let contentOffsetY = collectionView.contentOffset.y
                
                if contentOffsetY < 158 {
                    return
                }

                let width = collectionView.frame.width
                let height = attributes.frame.height
                // TODO: Contant (heightCell - heightButton - topAnchor - bottomAnchor)
                let yPosition = contentOffsetY -
                    (Constants.mainGardenHeaderHeight - Constants.mainButtonHeight -
                        Constants.mainInsets.top - Constants.mainInsets.bottom)
                attributes.frame = CGRect(x: 0, y: yPosition, width: width, height: height)
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
