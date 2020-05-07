//
//  Constants.swift
//  MyGarden
//
//  Created by Никита on 07.05.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

struct Constants {
    
    static let mainGardenHeaderHeight: CGFloat = 240
    static let mainButtonHeight: CGFloat = 50
    static let mainInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    static let headerImageHeight: CGFloat = 340
    static let addPlantItemHeight: CGFloat = 355
    static let footerAddPlantHeight: CGFloat = mainButtonHeight + mainInsets.top + mainInsets.bottom
    
    static let buttonCornerRadius: CGFloat = 16
    
    static let headerTitleFont = UIFont.systemFont(ofSize: 30, weight: .medium)
    static let descriptionFont = UIFont.systemFont(ofSize: 20, weight: .regular)
}
